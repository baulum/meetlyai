# MeetlyAI

MeetlyAI is a dark-first Flutter desktop app for local meeting capture,
local-first transcription architecture, local persistence, Gemini summaries,
and meeting chat.

## What is implemented

- Material 3 desktop shell inspired by modern AI chat apps.
- Sidebar with searchable, pinnable, favoritable meetings.
- Recording surface with live levels, pause/resume, local audio asset handling,
  and source-aware mic/system/mixed contracts.
- Clean Architecture split between UI, domain interfaces, Drift persistence,
  native audio, transcription, Gemini, settings, and export services.
- Drift/SQLite schema for meetings, audio assets, transcript segments,
  summaries, action items, decisions, chat messages, settings, and FTS index.
- Gemini REST service with structured summary schema and streaming chat support.
- BYOK settings drawer storing the Gemini key in the OS secure store.
- Local packages:
  - `packages/native_audio_engine`: desktop plugin API for native audio capture.
  - `packages/whisper_ffi`: FFI package boundary for whisper.cpp integration.

## Native capture and Whisper status

The app layer is wired against production interfaces. The native packages expose
stable contracts and build successfully, but the low-level WASAPI,
ScreenCaptureKit, AVAudioEngine, and full whisper.cpp C API internals still need
to be filled in behind those contracts. Until then, the audio plugin provides a
development preview stream so the desktop UX and data flow can be exercised.

Transcription does not call any cloud Speech API. Gemini is used only for
summary and chat.

## Setup

```bash
flutter pub get
dart run build_runner build
flutter analyze
flutter test
flutter build macos
```

Windows builds must be run from a Windows host:

```bash
flutter build windows
```

## Runtime configuration

Open Settings in the app and configure:

- Gemini API key
- Gemini model, default: `gemini-2.5-flash`
- Local Whisper model path, for example a `ggml-*.bin` or `*.gguf` model
- Meeting language: auto, German, or English

For local transcription, MeetlyAI now looks for a `whisper.cpp` executable in
this order:

1. The Whisper executable path saved in Settings
2. `WHISPER_CPP_BIN`
3. `whisper-cli` on `PATH`
4. `main` on `PATH`
5. `/opt/homebrew/bin/whisper-cli`
6. `/usr/local/bin/whisper-cli`
7. `$HOME/whisper.cpp/build/bin/whisper-cli`
8. `command -v whisper-cli` via the user's login/interactive shell

The model path alone is not enough; a real whisper.cpp runtime must be
available, and the recorded WAV files must contain PCM audio data. A 44-byte WAV
file is only a header and cannot be transcribed.

On macOS, apps launched by Flutter/Xcode often do not inherit the same `PATH`
as your Terminal. If `whisper-cli` works in Terminal but MeetlyAI cannot find
it, run `which whisper-cli` in Terminal and paste that full path into Settings.
