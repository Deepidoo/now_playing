import 'package:flutter/services.dart';

/// NowPlaying is a Flutter plugin that provides easy integration with iOS Now Playing controls and information display.
/// This package allows you to update the Now Playing information and handle remote control events for media playback.
class NowPlayingView {
  static final NowPlayingView instance = NowPlayingView._internal();
  static MethodChannel? _channel;
  bool _isInitialized = false;

  /// Private constructor for the NowPlaying class.
  NowPlayingView._internal();

  /// Initialize the NowPlaying plugin with the necessary event handlers.
  ///
  /// This method sets up the remote command handlers for media playback events.
  /// It also sets up the method call handler to handle events from the native iOS Now Playing plugin.
  ///
  /// Parameters:
  /// - [onPlay] : A function to handle the play event.
  /// - [onPause] : A function to handle the pause event.
  /// - [onNextTrack] : A function to handle the next track event.
  /// - [onPreviousTrack] : A function to handle the previous track event.
  /// - [onSeek] : A function to handle the seek event.
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

  /// Update the Now Playing information.
  ///
  /// This method updates the Now Playing information in the iOS Now Playing plugin.
  ///
  /// Parameters:
  /// - [title]   : The title of the current track.
  /// - [artist] : The artist of the current track.
  /// - [duration] : The duration of the current track in seconds.
  /// - [currentTime] : The current playback time of the track in seconds.
  /// - [playbackRate] : The playback rate of the track.
  /// - [imageUrl] : The URL of the album art image.
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
          'NowPlayingView is not initialized. Call initialize() first.');
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
}
