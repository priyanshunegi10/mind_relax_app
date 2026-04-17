import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mind_relax_app/data/model/ambience_model.dart';

class PlayerProvider extends ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;

  AmbienceModel? _currentAmbience;
  int _remainingSeconds = 0;
  bool _isPlaying = false;
  bool _isSessionActive = false;

  // Getters
  AmbienceModel? get currentAmbience => _currentAmbience;
  int get remainingSeconds => _remainingSeconds;
  bool get isPlaying => _isPlaying;
  bool get isSessionActive => _isSessionActive;
  int get totalSeconds => _currentAmbience?.durationSeconds ?? 0;
  int get elapsedSeconds => totalSeconds - _remainingSeconds;

  Future<void> startSession(AmbienceModel ambience) async {
    await stopAndClear();

    _currentAmbience = ambience;
    _remainingSeconds = ambience.durationSeconds;
    _isSessionActive = true;
    _isPlaying = true;
    notifyListeners();

    try {
      await _audioPlayer.setAsset(ambience.audioUrl);
      await _audioPlayer.setLoopMode(LoopMode.one);
      _audioPlayer.play();

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          notifyListeners();
        } else {
          endSessionComplete();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print("Audio loading error: $e");
      }

      stopAndClear();
    }
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
      _isPlaying = false;
    } else {
      _audioPlayer.play();
      _isPlaying = true;
    }
    notifyListeners();
  }

  void endSessionComplete() {
    stopAndClear();
  }

  Future<void> stopAndClear() async {
    _timer?.cancel();
    await _audioPlayer.stop();
    _isPlaying = false;
    _isSessionActive = false;

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  void seekSession(int seconds) {
    if (seconds < 0) seconds = 0;
    if (seconds > totalSeconds) seconds = totalSeconds;

    _remainingSeconds = totalSeconds - seconds;
    notifyListeners();
  }
}
