import Foundation
import MediaPlayer

enum PlayerState {
    case playing
    case paused
    case stopped
    case unknown
}

class MediaPlayerHelper {
    static func getPlayerState(forApp appName: String) -> PlayerState {
        let appleScript = """
        tell application "\(appName)"
            if it is running then
                get player state
            else
                return "stopped"
            end if
        end tell
        """

        let state = runAppleScript(appleScript)
        switch state {
        case "playing":
            return .playing
        case "paused":
            return .paused
        case "stopped":
            return .stopped
        default:
            return .unknown
        }
    }

    static func pausePlayback(forApp appName: String) {
        let appleScript = """
        tell application "\(appName)"
            if it is running then
                pause
            end if
        end tell
        """
        runAppleScript(appleScript)
    }

    static func resumePlayback(forApp appName: String) {
        let appleScript = """
        tell application "\(appName)"
            if it is running then
                play
            end if
        end tell
        """
        runAppleScript(appleScript)
    }

    private static func runAppleScript(_ script: String) -> String {
        let appleScript = NSAppleScript(source: script)
        var error: NSDictionary?
        let output = appleScript?.executeAndReturnError(&error).stringValue ?? "unknown"

        if let error = error {
            print("AppleScript Error: \(error)")
        }

        return output
    }
}
