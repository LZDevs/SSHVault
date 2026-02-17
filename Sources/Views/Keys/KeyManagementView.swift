import SwiftUI

struct KeyManagementView: View {
    var isInline: Bool = false

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var tm = ThemeManager.shared
    @State private var keys: [SSHKeyInfo] = []
    @State private var showingGenerate = false
    @State private var newKeyName = ""
    @State private var newKeyType = "ed25519"
    @State private var newKeyComment = ""
    @State private var newKeyPassphrase = ""
    @State private var generationResult: String?
    @State private var copiedKeyID: String?

    private let keyService = SSHKeyService.shared
    private var t: AppTheme { tm.current }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("SSH Keys")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(t.foreground)
                Spacer()
                Button { showingGenerate = true } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus").font(.system(size: 11, weight: .semibold))
                        Text("Generate").font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(t.green)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(RoundedRectangle(cornerRadius: 6).fill(t.green.opacity(0.12)))
                    .overlay(RoundedRectangle(cornerRadius: 6).strokeBorder(t.green.opacity(0.25), lineWidth: 0.5))
                }.buttonStyle(.plain)
                if !isInline {
                    Button("Done") { dismiss() }.keyboardShortcut(.cancelAction)
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 12)

            Rectangle().fill(t.secondary.opacity(0.2)).frame(height: 0.5)

            if keys.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(keys) { key in keyCard(key) }
                    }.padding(16)
                }
            }

            Rectangle().fill(t.secondary.opacity(0.2)).frame(height: 0.5)
            HStack {
                Image(systemName: "folder").font(.system(size: 11)).foregroundColor(t.secondary.opacity(0.6))
                Text("~/.ssh/").font(.system(size: 10.5, design: .monospaced)).foregroundColor(t.secondary.opacity(0.6))
                Spacer()
                Text("\(keys.count) key\(keys.count == 1 ? "" : "s")")
                    .font(.system(size: 10.5)).foregroundColor(t.secondary.opacity(0.7))
            }.padding(.horizontal, 16).padding(.vertical, 6)
        }
        .background(t.background)
        .task { refreshKeys() }
        .sheet(isPresented: $showingGenerate) { generateKeySheet }
        .alert("Key Generated", isPresented: .init(
            get: { generationResult != nil }, set: { if !$0 { generationResult = nil } }
        )) { Button("OK") { generationResult = nil } } message: { Text(generationResult ?? "") }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 14) {
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 16).fill(t.accent.opacity(0.08)).frame(width: 64, height: 64)
                Image(systemName: "key.fill").font(.system(size: 28)).foregroundColor(t.accent.opacity(0.5))
            }
            Text("No SSH keys found").font(.system(size: 15, weight: .semibold)).foregroundColor(t.foreground.opacity(0.7))
            Text("Keys in ~/.ssh/ will appear here").font(.system(size: 12)).foregroundColor(t.secondary)
            Button { showingGenerate = true } label: {
                HStack(spacing: 5) {
                    Image(systemName: "plus").font(.system(size: 11, weight: .semibold))
                    Text("Generate New Key").font(.system(size: 12.5, weight: .medium))
                }
                .foregroundColor(t.green)
                .padding(.horizontal, 14).padding(.vertical, 7)
                .background(RoundedRectangle(cornerRadius: 7).fill(t.green.opacity(0.12)))
                .overlay(RoundedRectangle(cornerRadius: 7).strokeBorder(t.green.opacity(0.3), lineWidth: 0.5))
            }.buttonStyle(.plain).padding(.top, 4)
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Key Card

    func keyCard(_ key: SSHKeyInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8).fill(t.pink.opacity(0.12)).frame(width: 34, height: 34)
                    Image(systemName: "key.fill").font(.system(size: 13, weight: .medium)).foregroundColor(t.pink)
                }
                VStack(alignment: .leading, spacing: 1) {
                    Text(key.name).font(.system(size: 12.5, weight: .semibold)).foregroundColor(t.foreground)
                    if !key.comment.isEmpty {
                        Text(key.comment).font(.system(size: 10.5)).foregroundColor(t.secondary).lineLimit(1)
                    }
                }
                Spacer()
                Text(key.keyType.uppercased())
                    .font(.system(size: 9.5, weight: .bold, design: .monospaced))
                    .foregroundColor(t.cyan)
                    .padding(.horizontal, 7).padding(.vertical, 3)
                    .background(Capsule().fill(t.cyan.opacity(0.1)))
                    .overlay(Capsule().strokeBorder(t.cyan.opacity(0.2), lineWidth: 0.5))
                if key.hasPublicKey {
                    Button {
                        if keyService.copyPublicKey(key) {
                            copiedKeyID = key.id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { if copiedKeyID == key.id { copiedKeyID = nil } }
                        }
                    } label: {
                        HStack(spacing: 3) {
                            Image(systemName: copiedKeyID == key.id ? "checkmark" : "doc.on.doc").font(.system(size: 10))
                            Text(copiedKeyID == key.id ? "Copied!" : "Copy Pub").font(.system(size: 10.5, weight: .medium))
                        }
                        .foregroundColor(copiedKeyID == key.id ? t.green : t.accent)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 5).fill(
                            copiedKeyID == key.id ? t.green.opacity(0.12) : t.accent.opacity(0.1)))
                    }.buttonStyle(.plain)
                }
            }
            if !key.fingerprint.isEmpty {
                HStack(spacing: 6) {
                    Image(systemName: "number").font(.system(size: 9, weight: .medium)).foregroundColor(t.secondary.opacity(0.5))
                    Text(key.fingerprint).font(.system(size: 10, design: .monospaced)).foregroundColor(t.secondary)
                        .textSelection(.enabled).lineLimit(1).truncationMode(.middle)
                }
            }
            HStack(spacing: 6) {
                Image(systemName: "folder").font(.system(size: 9, weight: .medium)).foregroundColor(t.secondary.opacity(0.4))
                Text(key.privateKeyPath).font(.system(size: 10, design: .monospaced))
                    .foregroundColor(t.secondary.opacity(0.5)).lineLimit(1).truncationMode(.middle)
            }
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 9).fill(t.surface.opacity(0.6)))
        .overlay(RoundedRectangle(cornerRadius: 9).strokeBorder(t.secondary.opacity(0.15), lineWidth: 0.5))
    }

    // MARK: - Generate Sheet

    var generateKeySheet: some View {
        VStack(spacing: 0) {
            HStack { Text("Generate SSH Key").font(.headline); Spacer() }.padding()
            Divider()
            Form {
                TextField("Key Name", text: $newKeyName).help("Filename for the key (e.g., id_ed25519_work)")
                Picker("Key Type", selection: $newKeyType) {
                    Text("Ed25519 (Recommended)").tag("ed25519")
                    Text("RSA (4096-bit)").tag("rsa")
                    Text("ECDSA").tag("ecdsa")
                }
                TextField("Comment", text: $newKeyComment).help("Optional label for the key")
                SecureField("Passphrase", text: $newKeyPassphrase).help("Leave empty for no passphrase")
            }.formStyle(.grouped)
            Divider()
            HStack {
                Spacer()
                Button("Cancel") { showingGenerate = false }.keyboardShortcut(.cancelAction)
                Button("Generate") { generateKey() }.keyboardShortcut(.defaultAction)
                    .disabled(!isValidKeyName(newKeyName))
            }.padding()
        }.frame(width: 400, height: 320)
    }

    private func generateKey() {
        let name = newKeyName.trimmingCharacters(in: .whitespaces)
        let success = keyService.generateKey(name: name, type: newKeyType, comment: newKeyComment, passphrase: newKeyPassphrase)
        generationResult = success
            ? "Key \"\(name)\" generated successfully."
            : "Failed to generate key. A key with this name may already exist."
        newKeyName = ""; newKeyComment = ""; newKeyPassphrase = ""
        showingGenerate = false
        refreshKeys()
    }

    private func isValidKeyName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        let allowed = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "-_"))
        return !trimmed.isEmpty
            && !trimmed.hasPrefix(".")
            && !trimmed.contains("/")
            && trimmed.unicodeScalars.allSatisfy({ allowed.contains($0) })
    }

    private func refreshKeys() { keys = keyService.listKeys() }
}
