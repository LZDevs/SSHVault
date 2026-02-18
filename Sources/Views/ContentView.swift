import SwiftUI
import UniformTypeIdentifiers

enum NavSection: Hashable {
    case hosts, keys, settings
}

struct ContentView: View {
    @EnvironmentObject var configService: SSHConfigService
    @ObservedObject private var tm = ThemeManager.shared
    @State private var selectedNav: NavSection = .hosts
    @State private var editingHost: SSHHost?
    @State private var showingAddHost = false
    @State private var searchText = ""
    @State private var showingImport = false
    @State private var showingExport = false
    @State private var showingTermiusImport = false
    @State private var showingAbout = false
    @State private var exportDocument: SSHConfigDocument?

    private var t: AppTheme { tm.current }
    private var showRightPanel: Bool { editingHost != nil || showingAddHost }

    var body: some View {
        HStack(spacing: 0) {
            iconRail
            Rectangle().fill(t.secondary.opacity(0.15)).frame(width: 0.5)
            centerPanel.frame(minWidth: 280).layoutPriority(1)
            if showRightPanel {
                Rectangle().fill(t.secondary.opacity(0.15)).frame(width: 0.5)
                rightPanel.frame(width: 380)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .background(t.background)
        .preferredColorScheme(t.isDark ? .dark : .light)
        .animation(.easeInOut(duration: 0.2), value: showRightPanel)
        .animation(.easeInOut(duration: 0.2), value: editingHost?.id)
        .sheet(isPresented: $showingTermiusImport) { TermiusImportView() }
        .sheet(isPresented: $showingAbout) { AboutView() }
        .fileImporter(isPresented: $showingImport, allowedContentTypes: [.plainText, .data], allowsMultipleSelection: false) { handleImport($0) }
        .fileExporter(isPresented: $showingExport, document: exportDocument ?? SSHConfigDocument(content: ""), contentType: .plainText, defaultFilename: "ssh_config") { _ in exportDocument = nil }
    }

    // MARK: - Icon Rail

    private var iconRail: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 12)
            VStack(spacing: 4) {
                railButton(.hosts, icon: "server.rack", label: "Hosts")
                railButton(.keys, icon: "key.fill", label: "Keys")
                railButton(.settings, icon: "gearshape", label: "Settings")
            }
            Spacer()
            VStack(spacing: 6) {
                Rectangle().fill(t.secondary.opacity(0.15)).frame(width: 24, height: 0.5)
                Menu {
                    Button { showingImport = true } label: { Label("Import Config...", systemImage: "square.and.arrow.down") }
                    Button { showingTermiusImport = true } label: { Label("Import from Termius...", systemImage: "link") }
                    Button { exportDocument = SSHConfigDocument(content: configService.exportConfig()); showingExport = true } label: { Label("Export Config...", systemImage: "square.and.arrow.up") }
                    Divider()
                    Button { configService.load() } label: { Label("Reload Config", systemImage: "arrow.clockwise") }
                    Divider()
                    Button { showingAbout = true } label: { Label("About SSHMan", systemImage: "info.circle") }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 17))
                        .foregroundColor(t.secondary)
                        .frame(width: 50, height: 34)
                        .contentShape(Rectangle())
                }
                .menuStyle(.borderlessButton).frame(width: 50)
                .help("Import, export & more")
            }
            Spacer().frame(height: 10)
        }
        .frame(width: 58)
        .background(t.sidebar)
    }

    private func railButton(_ section: NavSection, icon: String, label: String) -> some View {
        let isActive = selectedNav == section
        return Button { selectedNav = section } label: {
            VStack(spacing: 1) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: isActive ? .semibold : .regular))
                    .frame(width: 28, height: 22)
                Text(label)
                    .font(.system(size: 9, weight: isActive ? .semibold : .regular))
            }
            .foregroundColor(isActive ? t.accent : t.secondary)
            .frame(width: 50, height: 42)
            .background(RoundedRectangle(cornerRadius: 8).fill(isActive ? t.accent.opacity(0.15) : Color.clear))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain).help(label).accessibilityLabel(label)
    }

    // MARK: - Center / Right

    @ViewBuilder
    private var centerPanel: some View {
        switch selectedNav {
        case .hosts:
            SidebarView(searchText: $searchText, showingAddHost: $showingAddHost,
                         onEdit: { showingAddHost = false; editingHost = $0 },
                         onConnect: { TerminalService.connect(to: $0) })
        case .keys: KeyManagementView(isInline: true)
        case .settings: SettingsView(isInline: true)
        }
    }

    @ViewBuilder
    private var rightPanel: some View {
        Group {
            if showingAddHost {
                HostFormView(mode: .add) { configService.addHost($0); showingAddHost = false }
                    onCancel: { showingAddHost = false }
            } else if let host = editingHost {
                HostFormView(mode: .edit(host)) { configService.updateHost($0); editingHost = nil }
                    onCancel: { editingHost = nil }
            }
        }
        .background(t.background)
    }

    private func handleImport(_ result: Result<[URL], Error>) {
        guard case .success(let urls) = result, let url = urls.first else { return }
        guard url.startAccessingSecurityScopedResource() else { return }
        defer { url.stopAccessingSecurityScopedResource() }
        if let content = try? String(contentsOf: url, encoding: .utf8) {
            configService.importConfig(from: content, replace: false)
        }
    }
}

// MARK: - File Document

struct SSHConfigDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }
    var content: String
    init(content: String) { self.content = content }
    init(configuration: ReadConfiguration) throws {
        content = configuration.file.regularFileContents.flatMap { String(data: $0, encoding: .utf8) } ?? ""
    }
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        FileWrapper(regularFileWithContents: content.data(using: .utf8) ?? Data())
    }
}
