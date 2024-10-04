import 'package:flutter/material.dart';
import 'dart:async';
import 'package:now_playing/now_playing_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Timer updateNowPlayingInfoTimer;

  @override
  void initState() {
    super.initState();
    NowPlayingView.instance.initialize(
      onPlay: () => print('Play'),
      onPause: () => print('Pause'),
      onNextTrack: () => print('Next Track'),
      onPreviousTrack: () => print('Previous Track'),
      onSeek: (time) => print('Seek to $time'),
    );

    updateNowPlayingInfoTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        NowPlayingView.instance.updateNowPlayingInfo(
          title: 'Song Title',
          artist: 'Artist Name',
          duration: 300,
          currentTime: 150,
          playbackRate: 1.0,
          imageUrl: 'https://example.com/image.jpg',
        );
      },
    );
  }

  @override
  void dispose() {
    updateNowPlayingInfoTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
