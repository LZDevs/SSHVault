import SwiftUI

struct HostRowView: View {
    let host: SSHHost
    var onEdit: (() -> Void)?
    var onConnect: (() -> Void)?

    @ObservedObject private var tm = ThemeManager.shared
    @State private var isHovered = false
    private var t: AppTheme { tm.current }

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(host.isWildcard
                        ? t.orange.opacity(0.15)
                        : t.accent.opacity(0.15))
                    .frame(width: 34, height: 34)
                Image(systemName: host.isWildcard ? "asterisk" : "server.rack")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(host.isWildcard ? t.orange : t.accent)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(host.displayName)
                    .font(.system(size: 12.5, weight: .semibold))
                    .foregroundColor(t.foreground)
                    .lineLimit(1)
                    .truncationMode(.tail)

                if !host.hostName.isEmpty {
                    Text(connectionString)
                        .font(.system(size: 10.5))
                        .foregroundColor(t.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                }
            }

            Spacer(minLength: 0)

            if isHovered, let onEdit {
                Button(action: onEdit) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(t.accent.opacity(0.2))
                            .frame(width: 26, height: 26)
                        Image(systemName: "pencil")
                            .font(.system(size: 10.5, weight: .semibold))
                            .foregroundColor(t.accent)
                    }
                }
                .buttonStyle(.plain)
                .transition(.scale(scale: 0.85).combined(with: .opacity))
                .help("Edit host")
            }
        }
        .padding(.horizontal, 11)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 9)
                .fill(isHovered
                    ? t.surface.opacity(0.9)
                    : t.surface.opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 9)
                .strokeBorder(
                    isHovered
                        ? t.accent.opacity(0.4)
                        : t.secondary.opacity(0.2),
                    lineWidth: 0.5
                )
        )
        .contentShape(Rectangle())
        .simultaneousGesture(
            TapGesture(count: 2).onEnded {
                onConnect?()
            }
        )
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("SSH Host \(host.displayName)")
        .accessibilityHint("Double click to connect")
        .accessibilityAction(.default) { onConnect?() }
    }

    private var connectionString: String {
        var parts: [String] = []
        if !host.user.isEmpty {
            parts.append("\(host.user)@\(host.hostName)")
        } else {
            parts.append(host.hostName)
        }
        if let port = host.port, port != TerminalService.defaultSSHPort {
            parts.append(":\(port)")
        }
        return parts.joined()
    }
}

// MARK: - Add Host Tile

struct AddHostTile: View {
    let action: () -> Void
    @ObservedObject private var tm = ThemeManager.shared
    @State private var isHovered = false
    private var t: AppTheme { tm.current }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(t.green.opacity(isHovered ? 0.2 : 0.1))
                        .frame(width: 34, height: 34)
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(t.green)
                }

                Text("Add Host")
                    .font(.system(size: 12.5, weight: .medium))
                    .foregroundColor(t.secondary)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 1, dash: [5, 3])
                    )
                    .foregroundColor(isHovered
                        ? t.green.opacity(0.4)
                        : t.secondary.opacity(0.3))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovered = hovering
            }
        }
    }
}
