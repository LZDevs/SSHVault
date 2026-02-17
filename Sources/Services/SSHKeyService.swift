import Foundation
import AppKit

/// Represents an SSH key pair found on disk
struct SSHKeyInfo: Identifiable, Hashable {
    let id: String  // filename of private key
    let privateKeyPath: String
    let publicKeyPath: String?
    let keyType: String
    let fingerprint: String
    let comment: String

    var name: String { id }
    var hasPublicKey: Bool { publicKeyPath != nil }
}

/// Manages SSH keys in ~/.ssh/
final class SSHKeyService {
    static let shared = SSHKeyService()

    private let sshDir: URL
    private let fm = FileManager.default

    private init() {
        sshDir = fm.homeDirectoryForCurrentUser.appendingPathComponent(".ssh", isDirectory: true)
    }

    /// Scan ~/.ssh/ for key pairs
    func listKeys() -> [SSHKeyInfo] {
        guard let files = try? fm.contentsOfDirectory(atPath: sshDir.path) else {
            return []
        }

        let pubFiles = Set(files.filter { $0.hasSuffix(".pub") })
        var keys: [SSHKeyInfo] = []

        // Find private keys (files that have a matching .pub or are known key names)
        let knownKeyNames: Set<String> = ["id_rsa", "id_ed25519", "id_ecdsa", "id_dsa"]
        let skipFiles: Set<String> = ["config", "config.bak", "config.tmp", "known_hosts",
                                       "known_hosts.old", "authorized_keys", "environment"]

        for file in files.sorted() {
            if file.hasPrefix(".") || file.hasSuffix(".pub") || skipFiles.contains(file) { continue }

            let hasPub = pubFiles.contains(file + ".pub")
            let isKnown = knownKeyNames.contains(file)

            // Heuristic: it's a key if it has a .pub companion or is a known key name
            // or we can check with ssh-keygen
            if hasPub || isKnown {
                let privatePath = sshDir.appendingPathComponent(file).path
                let publicPath = hasPub ? sshDir.appendingPathComponent(file + ".pub").path : nil
                let info = getKeyInfo(name: file, privatePath: privatePath, publicPath: publicPath)
                keys.append(info)
            }
        }

        return keys
    }

    private func getKeyInfo(name: String, privatePath: String, publicPath: String?) -> SSHKeyInfo {
        var keyType = "unknown"
        var fingerprint = ""
        var comment = ""

        // Try to get fingerprint from the key
        let targetPath = publicPath ?? privatePath
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/ssh-keygen")
        process.arguments = ["-l", "-f", targetPath]
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()

        if let _ = try? process.run() {
            process.waitUntilExit()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
               !output.isEmpty {
                // Output format: "256 SHA256:xxx comment (ED25519)"
                let parts = output.components(separatedBy: " ")
                if parts.count >= 2 {
                    fingerprint = parts[1]
                }
                // Key type is in parentheses at the end
                if let typeMatch = output.components(separatedBy: "(").last?.dropLast() {
                    keyType = String(typeMatch)
                }
                // Comment is between fingerprint and type
                if parts.count >= 3 {
                    let commentParts = parts[2..<parts.count]
                    let joined = commentParts.joined(separator: " ")
                    if let parenIdx = joined.lastIndex(of: "(") {
                        comment = String(joined[joined.startIndex..<parenIdx]).trimmingCharacters(in: .whitespaces)
                    } else {
                        comment = joined
                    }
                }
            }
        }

        return SSHKeyInfo(
            id: name,
            privateKeyPath: privatePath,
            publicKeyPath: publicPath,
            keyType: keyType,
            fingerprint: fingerprint,
            comment: comment
        )
    }

    /// Generate a new SSH key pair
    func generateKey(name: String, type: String = "ed25519", comment: String = "", passphrase: String = "") -> Bool {
        let safeName = name.trimmingCharacters(in: .whitespaces)

        // Reject path traversal and special characters
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        guard !safeName.isEmpty,
              !safeName.contains("/"),
              !safeName.contains("\\"),
              !safeName.hasPrefix("."),
              safeName.unicodeScalars.allSatisfy({ allowed.contains($0) }) else {
            return false
        }

        let keyPath = sshDir.appendingPathComponent(safeName).path

        // Don't overwrite existing keys
        if fm.fileExists(atPath: keyPath) {
            return false
        }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/ssh-keygen")
        process.arguments = [
            "-t", type,
            "-f", keyPath,
            "-N", passphrase,
            "-C", comment.isEmpty ? name : comment
        ]
        process.standardOutput = Pipe()
        process.standardError = Pipe()

        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }

    /// Copy a public key to clipboard
    func copyPublicKey(_ key: SSHKeyInfo) -> Bool {
        guard let pubPath = key.publicKeyPath,
              let content = try? String(contentsOfFile: pubPath, encoding: .utf8) else {
            return false
        }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(content.trimmingCharacters(in: .whitespacesAndNewlines), forType: .string)
        return true
    }
}
