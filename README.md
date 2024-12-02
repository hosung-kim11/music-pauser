# Music Pauser

I made this because when I pause an instructional video to take notes, I do not like the silence. Music Pauser is a macOS menu bar application that automatically pauses music playback on **Spotify** or **Apple Music** when another application starts playing audio. Once the other application stops playing audio, Music Pauser will resume music playback.

![Screenshot of in menu bar](https://github.com/hosung-kim11/music-pauser/blob/main/screenshot.jpeg?raw=true)

---

## Features

- Detects audio playback on the system's default audio output device.
- Supports automatic pausing and resuming for Spotify and Apple Music using the **Media Remote API**.
- Lightweight and efficient, with periodic polling to monitor audio activity.
- User-friendly menu bar interface to toggle auto-pause functionality.

---

## How It Works

1. **Audio Detection**:
   - Music Pauser continuously monitors the system's default audio output device to detect new audio streams from other applications.

2. **Playback State**:
   - The app uses the **Media Remote API** to check the playback state of Spotify and Apple Music (e.g., playing, paused, stopped).

3. **Logic**:
   - If other audio is detected and Spotify or Apple Music is playing, the app pauses the music.
   - If no other audio is detected and music was previously paused by the app, it resumes playback.
