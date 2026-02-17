import Foundation
import SwiftUI
import os

private let logger = Logger(subsystem: "com.lzdevs.sshman", category: "config")

/// Manages reading and writing ~/.ssh/config
final class SSHConfigService: ObservableObject {
    @Published var hosts: [SSHHost] = []
    @Published var groups: [HostGroup] = []

    private let configURL: URL
    private let fm = FileManager.default

    init() {
        let sshDir = fm.homeDirectoryForCurrentUser.appendingPathComponent(".ssh", isDirectory: true)
        self.configURL = sshDir.appendingPathComponent("config")

        // Ensure ~/.ssh/ exists
        if !fm.fileExists(atPath: sshDir.path) {
            try? fm.createDirectory(at: sshDir, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
        }

        load()
        groups = HostGroup.loadAll()
    }

    // MARK: - Load

    func load() {
        guard fm.fileExists(atPath: configURL.path),
              let content = try? String(contentsOf: configURL, encoding: .utf8) else {
            hosts = []
            return
        }
        hosts = SSHConfig.parse(content: content)
    }

    // MARK: - Save

    func save() {
        createBackup()

        let content = SSHConfig.serialize(hosts: hosts)
        let sshDir = configURL.deletingLastPathComponent()

        // Atomic write: write to temp, then swap atomically
        let tempURL = sshDir.appendingPathComponent("config.tmp")
        do {
            try content.write(to: tempURL, atomically: true, encoding: .utf8)
            try fm.setAttributes([.posixPermissions: 0o600], ofItemAtPath: tempURL.path)
            _ = try fm.replaceItemAt(configURL, withItemAt: tempURL)
        } catch {
            logger.error("Failed to save SSH config: \(error.localizedDescription, privacy: .private)")
            // Clean up temp file if it still exists
            try? fm.removeItem(at: tempURL)
        }
    }

    private func createBackup() {
        let backupURL = configURL.deletingLastPathComponent().appendingPathComponent("config.bak")
        if fm.fileExists(atPath: configURL.path) {
            try? fm.removeItem(at: backupURL)
            try? fm.copyItem(at: configURL, to: backupURL)
            try? fm.setAttributes([.posixPermissions: 0o600], ofItemAtPath: backupURL.path)
        }
    }

    // MARK: - CRUD

    func addHost(_ host: SSHHost) {
        hosts.append(host)
        save()
    }

    func updateHost(_ host: SSHHost) {
        if let index = hosts.firstIndex(where: { $0.id == host.id }) {
            hosts[index] = host
            save()
        }
    }

    func deleteHost(_ host: SSHHost) {
        hosts.removeAll { $0.id == host.id }
        // Remove from groups too
        for i in groups.indices {
            groups[i].hostIDs.removeAll { $0 == host.host }
        }
        save()
        saveGroups()
    }

    // MARK: - Groups

    func addGroup(_ group: HostGroup) {
        groups.append(group)
        saveGroups()
    }

    func saveGroups() {
        HostGroup.saveAll(groups)
    }

    // MARK: - Import/Export

    func exportConfig(hosts hostsToExport: [SSHHost]? = nil) -> String {
        let toExport = hostsToExport ?? hosts
        return SSHConfig.serialize(hosts: toExport)
    }

    func importConfig(from content: String, replace: Bool = false) {
        var imported = SSHConfig.parse(content: content)
        // Sanitize imported hosts
        for i in imported.indices {
            imported[i] = SSHConfig.sanitizeHost(imported[i])
        }
        if replace {
            hosts = imported
        } else {
            // Merge: add new hosts, skip duplicates by alias
            let existingAliases = Set(hosts.map { $0.host })
            for host in imported {
                if !existingAliases.contains(host.host) {
                    hosts.append(host)
                }
            }
        }
        save()
    }
}
