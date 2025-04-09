import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
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
  late AudioPlayer audioPlayer;
  late AudioPlayer audioPlayer2;

  List<String> songs = [
    'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
    'https://download.samplelib.com/mp3/sample-15s.mp3',
    'https://download.samplelib.com/mp3/sample-12s.mp3',
    'https://download.samplelib.com/mp3/sample-9s.mp3',
    'https://download.samplelib.com/mp3/sample-6s.mp3',
    'https://download.samplelib.com/mp3/sample-3s.mp3',
  ];
  List<String> songTitles = [
    'Kalimba',
    'Sample 15s',
    'Sample 12s',
    'Sample 9s',
    'Sample 6s',
    'Sample 3s',
  ];
  List<String> songArtists = [
    'Kalimba',
    'Artist 15s',
    'Artist 12s',
    'Artist 9s',
    'Artist 6s',
    'Artist 3s',
  ];
  List<String> songImages = [
    'https://example.com/image.jpg',
    'https://example.com/image.jpg',
    'https://example.com/image.jpg',
    'https://example.com/image.jpg',
    'https://example.com/image.jpg',
    'https://example.com/image.jpg',
  ];
  int currentSongIndex = 0;

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer2 = AudioPlayer();
    NowPlayingView.instance.initialize(
      onPlay: () => audioPlayer.play(),
      onPause: () => audioPlayer.pause(),
      onNextTrack: () => playNext(),
      onPreviousTrack: () => playPrevious(),
      onSeek: (time) => audioPlayer.seek(Duration(seconds: time)),
    );

    updateNowPlayingInfoTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        NowPlayingView.instance.updateNowPlayingInfo(
          title: songTitles[currentSongIndex],
          artist: songArtists[currentSongIndex],
          duration: 300,
          currentTime: 150,
          playbackRate: 1.0,
          imageUrl: songImages[currentSongIndex],
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
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Hello World'),
            ElevatedButton(
              onPressed: () => _startMusic(),
              child: const Text('Update Now World'),
            ),
            ElevatedButton(
              onPressed: () => playNext(),
              child: const Text('Play Next'),
            ),
            ElevatedButton(
              onPressed: () => playPrevious(),
              child: const Text('Play Previous'),
            ),
            StreamBuilder<Duration>(
                stream: audioPlayer.positionStream,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data?.inSeconds ?? '0'} seconds',
                  );
                }),
          ],
        ),
      ),
    );
  }

  void _startMusic() {
    audioPlayer
        .setAudioSource(AudioSource.uri(Uri.parse(songs[currentSongIndex])));
    audioPlayer.play();
    audioPlayer2
        .setAudioSource(AudioSource.uri(Uri.parse(songs[currentSongIndex])));
    audioPlayer2.play();
  }

  void playNext() {
    currentSongIndex++;
    if (currentSongIndex >= songs.length) {
      currentSongIndex = 0;
    }
    _startMusic();
  }

  void playPrevious() {
    currentSongIndex--;
    if (currentSongIndex < 0) {
      currentSongIndex = songs.length - 1;
    }
    _startMusic();
  }
}
