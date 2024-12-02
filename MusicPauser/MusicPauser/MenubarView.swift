import SwiftUI

struct MenubarView: View {
    @ObservedObject var audioMonitor: AudioMonitor

    var body: some View {
        VStack {
            Text("Music Pauser")
                .font(.headline)
                .padding(.top)

            Divider()

            Toggle("Enable Auto-Pause", isOn: $audioMonitor.isAutoPauseEnabled)
                .toggleStyle(SwitchToggleStyle())
                .padding()

            Button(action: {
                audioMonitor.pauseMusic()
            }) {
                Text("Pause Music Now")
            }
            .padding()

            Button(action: quitApp) {
                Text("Quit")
                    .foregroundColor(.red)
            }
            .padding(.bottom)
        }
        .frame(width: 200)
        .padding()
    }

    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
