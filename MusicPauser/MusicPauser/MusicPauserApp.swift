import SwiftUI

@main
struct MusicPauserApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    var audioMonitor: AudioMonitor!

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "music.note", accessibilityDescription: "Music Pauser")
            button.action = #selector(togglePopover)
        }


        popover = NSPopover()
        audioMonitor = AudioMonitor()
        popover.contentViewController = NSHostingController(rootView: MenubarView(audioMonitor: audioMonitor))
        popover.behavior = .transient
        audioMonitor = AudioMonitor()
    }

    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
