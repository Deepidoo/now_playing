# NowPlayingView

NowPlayingView is a Flutter plugin that provides easy integration with iOS Now Playing controls and information display. This package allows you to update the Now Playing information and handle remote control events for media playback.

## Features

- Update Now Playing information (title, artist, duration, current time, playback rate, and image URL)
- Handle remote control events (play, pause, next track, previous track, and seek)
- Easy initialization and setup

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  now_playing_view: ^0.0.1
```

Then run:

```bash
flutter pub get
```

OR

```bash
flutter pub add now_playing
```

## Usage

### Initialization

Before using the NowPlayingView functionality, you need to initialize it with the necessary event handlers:

```dart
NowPlayingView.instance.initialize(
  onPlay: () {
    // Handle play event
  },
  onPause: () {
    // Handle pause event
  },
  onNextTrack: () {
    // Handle next track event
  },
  onPreviousTrack: () {
    // Handle previous track event
  },
  onSeek: (time) {
    // Handle seek event
  },
);
```

### Updating Now Playing Information

You can update the Now Playing information at any time using the `updateNowPlayingViewInfo` method:

```dart
await NowPlayingView.instance.updateNowPlayingViewInfo(
  title: 'Song Title',
  artist: 'Artist Name',
  duration: 180.0, // Total duration in seconds
  currentTime: 45.0, // Current playback position in seconds
  playbackRate: 1.0, // Playback rate (1.0 for normal speed)
  imageUrl: 'https://example.com/album_cover.jpg',
);
```

## Notes

- This plugin currently supports iOS only. Android support may be added in future versions.
- Make sure to call `initialize()` before using any other methods of the NowPlayingView instance.
- The `imageUrl` parameter in `updateNowPlayingViewInfo` should be a valid URL to an image file.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Issues and Feedback

Please file specific issues, bugs, or feature requests in our [issue tracker](https://github.com/Deepidoo/now_playing/issues).

## Author

Deepidoo (c.alexandre@deepidoo.com)
