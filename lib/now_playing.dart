import 'package:flutter/services.dart';

class NowPlaying {
  static final NowPlaying instance = NowPlaying._internal();
  static MethodChannel? _channel;
  bool _isInitialized = false;

  NowPlaying._internal();

  Future<void> updateNowPlayingInfo({
    required String title,
    required String artist,
    required double duration,
    required double currentTime,
    required double playbackRate,
    required String imageUrl,
  }) async {
    if (!_isInitialized) {
      throw Exception(
          'NowPlayable is not initialized. Call initialize() first.');
    }
    await _channel!.invokeMethod('updateNowPlayingInfo', {
      'title': title,
      'artist': artist,
      'duration': duration,
      'currentTime': currentTime,
      'playbackRate': playbackRate,
      'imageUrl': imageUrl,
    });
  }

  Future<void> initialize({
    required Function onPlay,
    required Function onPause,
    required Function onNextTrack,
    required Function onPreviousTrack,
    required Function onSeek,
  }) async {
    _channel = const MethodChannel('com.deepidoo.dev/now_playing');
    await _channel!.invokeMethod('setupRemoteCommandHandlers');

    _channel!.setMethodCallHandler((call) {
      switch (call.method) {
        case 'onPlay':
          onPlay();
          break;
        case 'onPause':
          onPause();
          break;
        case 'onNextTrack':
          onNextTrack();
          break;
        case 'onPreviousTrack':
          onPreviousTrack();
          break;
        case 'onSeek':
          onSeek(call.arguments['time']);
          break;
      }
      return Future.value(null);
    });

    _isInitialized = true;
  }
}
