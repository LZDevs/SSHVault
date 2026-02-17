import SwiftUI
import AppKit

@main
struct SSHManApp: App {
    @StateObject private var configService = SSHConfigService()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(configService)
                .frame(minWidth: 850, minHeight: 450)
        }
        .windowStyle(.titleBar)
        .defaultSize(width: 1050, height: 650)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if #available(macOS 14.0, *) {
                NSApp.activate()
            } else {
                NSApp.activate(ignoringOtherApps: true)
            }
            NSApp.windows.first?.makeKeyAndOrderFront(nil)
        }
    }
}
