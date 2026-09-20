import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioPlaybackInfo {
  final String title;
  final String subTitle;
  final String url;
  final PlayerState state;
  final Duration position;
  final Duration duration;

  const AudioPlaybackInfo({
    this.title = '',
    this.subTitle = '',
    this.url = '',
    this.state = PlayerState.stopped,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });

  bool get isPlaying => state == PlayerState.playing;
  bool get isPaused => state == PlayerState.paused;
  bool get hasActiveAudio => url.isNotEmpty;

  AudioPlaybackInfo copyWith({
    String? title,
    String? subTitle,
    String? url,
    PlayerState? state,
    Duration? position,
    Duration? duration,
  }) {
    return AudioPlaybackInfo(
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      url: url ?? this.url,
      state: state ?? this.state,
      position: position ?? this.position,
      duration: duration ?? this.duration,
    );
  }
}

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final _stateController = StreamController<AudioPlaybackInfo>.broadcast();

  AudioPlaybackInfo _currentInfo = const AudioPlaybackInfo();

  Stream<AudioPlaybackInfo> get playbackStream => _stateController.stream;
  AudioPlaybackInfo get currentInfo => _currentInfo;

  AudioService() {
    _player.onPlayerStateChanged.listen((state) {
      _currentInfo = _currentInfo.copyWith(state: state);
      _stateController.add(_currentInfo);
    });

    _player.onPositionChanged.listen((pos) {
      _currentInfo = _currentInfo.copyWith(position: pos);
      _stateController.add(_currentInfo);
    });

    _player.onDurationChanged.listen((dur) {
      _currentInfo = _currentInfo.copyWith(duration: dur);
      _stateController.add(_currentInfo);
    });

    _player.onPlayerComplete.listen((_) {
      _currentInfo = _currentInfo.copyWith(
        state: PlayerState.completed,
        position: Duration.zero,
      );
      _stateController.add(_currentInfo);
    });
  }

  Future<void> playAudio({
    required String url,
    required String title,
    required String subTitle,
  }) async {
    try {
      if (_currentInfo.url == url && _currentInfo.isPaused) {
        await _player.resume();
        return;
      }

      _currentInfo = AudioPlaybackInfo(
        title: title,
        subTitle: subTitle,
        url: url,
        state: PlayerState.playing,
      );
      _stateController.add(_currentInfo);

      await _player.stop();
      await _player.play(UrlSource(url));
    } catch (e) {
      debugPrint('Audio playback error: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentInfo.isPlaying) {
      await _player.pause();
    } else if (_currentInfo.isPaused) {
      await _player.resume();
    }
  }

  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> stop() async {
    await _player.stop();
    _currentInfo = const AudioPlaybackInfo();
    _stateController.add(_currentInfo);
  }

  void dispose() {
    _player.dispose();
    _stateController.close();
  }
}
