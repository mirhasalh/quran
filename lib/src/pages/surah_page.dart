import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../quran/models.dart';
import '../quran/states.dart';
import '../shared/arabic_surah_text.dart';
import '../shared/playback_control.dart';
import '../shared/surah_title.dart';

class SurahPage extends StatefulWidget {
  static const routeName = '/surah';

  const SurahPage({super.key});

  @override
  State<SurahPage> createState() => _SurahPageState();
}

class _SurahPageState extends State<SurahPage> {
  late AudioPlayer _player = AudioPlayer();
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  int _ayahNumber = 0;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  @override
  void dispose() {
    _player.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: BlocBuilder<SurahCubit, Surah?>(
          builder: (context, state) {
            if (state == null) {
              return const SizedBox();
            }

            return SurahTitle(
              name: state.name!,
              englishName: state.englishName!,
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () => _navToSurahs(),
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 100.0),
            child: BlocBuilder<SurahCubit, Surah?>(
              builder: (context, state) {
                if (state!.ayahs == null) {
                  return const Text('No data', textAlign: TextAlign.center);
                }

                return ArabicSurahText(
                  ayahs: state.ayahs!,
                  activeAyahNumber: _ayahNumber,
                  onAyahTap: (v) => _setAudioSource(v.number!, v.audio!),
                );
              },
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            bottom: _ayahNumber < 1 ? -100.0 : 0.0,
            child: PlaybackControl(
              duration: _duration,
              position: _position,
              onChanged: (value) {
                final duration = _duration;
                if (duration == null) {
                  return;
                }
                final position = value * duration.inMilliseconds;
                _player.seek(Duration(milliseconds: position.round()));
              },
              value:
                  (_position != null &&
                      _duration != null &&
                      _position!.inMilliseconds > 0 &&
                      _position!.inMilliseconds < _duration!.inMilliseconds)
                  ? _position!.inMilliseconds / _duration!.inMilliseconds
                  : 0.0,
              isPlaying: _playerState == PlayerState.playing,
              onPause: () => _pause(),
              onPlay: () => _play(),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _setAudioSource(int ayahNumber, String audio) async {
    if (ayahNumber == _ayahNumber) return;
    setState(() => _ayahNumber = ayahNumber);
    _player = AudioPlayer();
    _player.setReleaseMode(ReleaseMode.stop);
    await _player.setSourceUrl(audio);
    _playerState = _player.state;
    _player.getDuration().then(
      (value) => setState(() {
        _duration = value;
      }),
    );
    _player.getCurrentPosition().then(
      (value) => setState(() {
        _position = value;
      }),
    );
    _initStreams();
  }

  void _initStreams() {
    _durationSubscription = _player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = _player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = _player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription = _player.onPlayerStateChanged.listen((
      state,
    ) {
      setState(() {
        _playerState = state;
      });
    });
  }

  Future<void> _play() async {
    await _player.resume();
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await _player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  void _navToSurahs() => Navigator.of(context).pushNamed('/surahs');
}
