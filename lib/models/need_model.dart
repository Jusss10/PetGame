import 'dart:async';
import 'package:pet_game/models/speed_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeedModel {
  int hungerLevel = 10;
  int dirtyLevel = 10;
  int attentionLevel = 10;
  int sleepLevel = 10;

  late SharedPreferences prefs;
  bool isSleeping = false;

  final StreamController<int> _hungerController = StreamController<int>.broadcast();
  final StreamController<int> _dirtyController = StreamController<int>.broadcast();
  final StreamController<int> _attentionController = StreamController<int>.broadcast();
  final StreamController<int> _sleepController = StreamController<int>.broadcast();

  Stream<int> get hungerStream => _hungerController.stream;
  Stream<int> get dirtyStream => _dirtyController.stream;
  Stream<int> get attentionStream => _attentionController.stream;
  Stream<int> get sleepStream => _sleepController.stream;

  void initNeeds() {
    _hungerController.add(hungerLevel);
    _dirtyController.add(dirtyLevel);
    _attentionController.add(attentionLevel);
    _sleepController.add(sleepLevel);

    _startNeedDepletion();
  }

  Future<void> loadNeeds() async {
    hungerLevel = prefs.getInt('hungerLevel') ?? 10;
    dirtyLevel = prefs.getInt('dirtyLevel') ?? 10;
    attentionLevel = prefs.getInt('attentionLevel') ?? 10;
    sleepLevel = prefs.getInt('sleepLevel') ?? 10;

    _hungerController.sink.add(hungerLevel);
    _dirtyController.sink.add(dirtyLevel);
    _attentionController.sink.add(attentionLevel);
    _sleepController.sink.add(sleepLevel);
  }

  Future<void> saveNeeds() async {
    await prefs.setInt('hungerLevel', hungerLevel);
    await prefs.setInt('dirtyLevel', dirtyLevel);
    await prefs.setInt('attentionLevel', attentionLevel);
    await prefs.setInt('sleepLevel', sleepLevel);
  }

  /// Starts decreasing needs over time
  void _startNeedDepletion() {
    _decreaseHunger();
    _decreaseDirty();
    _decreaseAttention();
    _decreaseSleep();
  }

  void _decreaseHunger() {
    Timer.periodic(Duration(seconds: 10 + SpeedSettings.currentInterval), (timer) {
      if (!isSleeping && hungerLevel > 0) {
        hungerLevel -= (1).toInt().clamp(0, 10);
        _hungerController.add(hungerLevel);
      }
    });
  }

  void _decreaseDirty() {
    Timer.periodic(Duration(seconds: 10 + SpeedSettings.currentInterval), (timer) {
      if (!isSleeping && dirtyLevel > 0) {
        dirtyLevel -= (1).toInt().clamp(0, 10);
        _dirtyController.add(dirtyLevel);
      }
    });
  }

  void _decreaseAttention() {
    Timer.periodic(Duration(seconds: 10 + SpeedSettings.currentInterval), (timer) {
      if (!isSleeping && attentionLevel > 0) {
        attentionLevel -= (1).toInt().clamp(0, 10);
        _attentionController.add(attentionLevel);
      }
    });
  }

  void _decreaseSleep() {
    Timer.periodic(Duration(seconds: 30 + SpeedSettings.currentInterval), (timer) {
      if (!isSleeping && sleepLevel > 0) {
        sleepLevel -= 1;
        _sleepController.add(sleepLevel);

        if (sleepLevel == 0) {
          isSleeping = true;
        }
      }
      if (isSleeping) {
        sleepLevel += 1;
        _sleepController.add(sleepLevel);
        if (sleepLevel >= 10) {
          isSleeping = false;
        }
      }
    });
  }

  void updateHungerLevel(int newLevel) {
    hungerLevel = newLevel.clamp(0, 10);
    _hungerController.add(hungerLevel);
  }

  void updateDirtyLevel(int newLevel) {
    dirtyLevel = newLevel.clamp(0, 10);
    _dirtyController.add(dirtyLevel);
  }

  void updateAttentionLevel(int newLevel) {
    attentionLevel = newLevel.clamp(0, 10);
    _attentionController.add(attentionLevel);
  }

  void updateSleepLevel(int newLevel) {
    sleepLevel = newLevel.clamp(0, 10);
    _sleepController.add(sleepLevel);
  }

}

