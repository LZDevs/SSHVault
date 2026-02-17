import Foundation
import os

private let logger = Logger(subsystem: "com.lzdevs.sshman", category: "groups")

struct HostGroup: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var hostIDs: [String] // host aliases belonging to this group

    init(id: UUID = UUID(), name: String = "", hostIDs: [String] = []) {
        self.id = id
        self.name = name
        self.hostIDs = hostIDs
    }

    static let supportDir: URL = {
        guard let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
            fatalError("Application Support directory unavailable")
        }
        let url = base.appendingPathComponent("SSHMan", isDirectory: true)
        try? FileManager.default.createDirectory(
            at: url, withIntermediateDirectories: true,
            attributes: [.posixPermissions: 0o700]
        )
        return url
    }()

    static let storageURL = supportDir.appendingPathComponent("groups.json")

    static func loadAll() -> [HostGroup] {
        guard FileManager.default.fileExists(atPath: storageURL.path),
              let data = try? Data(contentsOf: storageURL),
              let groups = try? JSONDecoder().decode([HostGroup].self, from: data) else {
            return []
        }
        return groups
    }

    static func saveAll(_ groups: [HostGroup]) {
        guard let data = try? JSONEncoder().encode(groups) else { return }
        do {
            try data.write(to: storageURL, options: .atomic)
            try FileManager.default.setAttributes([.posixPermissions: 0o600], ofItemAtPath: storageURL.path)
        } catch {
            logger.error("Failed to save groups: \(error.localizedDescription, privacy: .private)")
        }
    }
}
