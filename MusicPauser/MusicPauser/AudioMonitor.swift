import Foundation
import CoreAudio
import Combine
import MediaPlayer

@MainActor
class AudioMonitor: ObservableObject {
    @Published var isAutoPauseEnabled: Bool = true
    private var isMusicPaused = false
    private var timer: Timer?

    init() {
        startPollingAudioStreams()
    }

    deinit {
//        stopPollingAudioStreams()
    }

    private func startPollingAudioStreams() {
        stopPollingAudioStreams()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(checkAudioStreams), userInfo: nil, repeats: true)
    }

    private func stopPollingAudioStreams() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func checkAudioStreams() {
        guard isAutoPauseEnabled else { return }

        let otherAudioPlaying = isOtherAudioPlaying()
        let musicPlaying = isMusicPlaying()

        if otherAudioPlaying && musicPlaying && !isMusicPaused {
            print("Other audio detected. Pausing music.")
            isMusicPaused = true
            pauseMusic()
        } else if !otherAudioPlaying && isMusicPaused {
            print("No other audio detected. Resuming music.")
            isMusicPaused = false
            resumeMusic()
        }
    }

    
    private func isMusicPlaying() -> Bool {
        let appleMusicState = MediaPlayerHelper.getPlayerState(forApp: "Music")
        let spotifyState = MediaPlayerHelper.getPlayerState(forApp: "Spotify")

        return appleMusicState == .playing || spotifyState == .playing
    }

    
    private func isOtherAudioPlaying() -> Bool {
        guard let deviceID = getDefaultOutputDeviceID() else { return false }

        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreamConfiguration,
            mScope: kAudioObjectPropertyScopeOutput,
            mElement: kAudioObjectPropertyElementMain
        )

        var propertySize: UInt32 = 0
        let statusSize = AudioObjectGetPropertyDataSize(deviceID, &propertyAddress, 0, nil, &propertySize)
        guard statusSize == noErr else { return false }

        let audioBufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: Int(propertySize))
        defer { audioBufferList.deallocate() }

        let status = AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, nil, &propertySize, audioBufferList)
        guard status == noErr else { return false }

        let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
        for buffer in buffers {
            if buffer.mDataByteSize > 0 {
                return true
            }
        }
        return false
    }

    private func getDefaultOutputDeviceID() -> AudioDeviceID? {
        var propertyAddress = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultOutputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        var deviceID = AudioDeviceID()
        var propertySize = UInt32(MemoryLayout<AudioDeviceID>.size)

        let status = AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &propertyAddress,
            0,
            nil,
            &propertySize,
            &deviceID
        )

        return status == noErr ? deviceID : nil
    }

    func pauseMusic() {
        print("Pausing music")
        MediaPlayerHelper.pausePlayback(forApp: "Music")
        MediaPlayerHelper.pausePlayback(forApp: "Spotify")
    }

    private func resumeMusic() {
        print("Resuning Music")
        MediaPlayerHelper.resumePlayback(forApp: "Music")
        MediaPlayerHelper.resumePlayback(forApp: "Spotify")
    }
}
