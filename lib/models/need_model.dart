import 'dart:async';
import 'package:pet_game/models/speed_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeedModel {
  // Singleton instance
  static final NeedModel _instance = NeedModel._internal();

  factory NeedModel() {
    return _instance;
  }

  NeedModel._internal(); // Private constructor

  int hungerLevel = 10;
  int dirtyLevel = 10;
  int attentionLevel = 10;
  int sleepLevel = 10;

  SharedPreferencesWithCache? prefs;
  bool isSleeping = false;
  List<Timer> _activeTimers = [];

  final StreamController<int> _hungerController = StreamController<int>.broadcast();
  final StreamController<int> _dirtyController = StreamController<int>.broadcast();
  final StreamController<int> _attentionController = StreamController<int>.broadcast();
  final StreamController<int> _sleepController = StreamController<int>.broadcast();

  Stream<int> get hungerStream => _hungerController.stream;
  Stream<int> get dirtyStream => _dirtyController.stream;
  Stream<int> get attentionStream => _attentionController.stream;
  Stream<int> get sleepStream => _sleepController.stream;

  int interval = SpeedSettings.currentInterval;

  Future<void> initPrefs() async {
    prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: <String>{'hungerLevel', 'dirtyLevel', 'attentionLevel', 'sleepLevel'},
      ),
    );
  }

  Future<void> loadNeeds() async {
    if (prefs == null) {
      await initPrefs();
    }
    hungerLevel = prefs?.getInt('hungerLevel') ?? 10;
    dirtyLevel = prefs?.getInt('dirtyLevel') ?? 10;
    attentionLevel = prefs?.getInt('attentionLevel') ?? 10;
    sleepLevel = prefs?.getInt('sleepLevel') ?? 10;

    _updateStreams();
  }

  Future<void> saveNeeds() async {
    if (prefs == null) {
      await initPrefs();
    }
    await prefs?.setInt('hungerLevel', hungerLevel);
    await prefs?.setInt('dirtyLevel', dirtyLevel);
    await prefs?.setInt('attentionLevel', attentionLevel);
    await prefs?.setInt('sleepLevel', sleepLevel);
  }

  Future<void> initNeeds() async {
    await initPrefs();
    _updateStreams();
    _startNeedDepletion();
  }

  void _updateStreams() {
    _hungerController.add(hungerLevel);
    _dirtyController.add(dirtyLevel);
    _attentionController.add(attentionLevel);
    _sleepController.add(sleepLevel);
  }

  void _startNeedDepletion() {
    _decreaseHunger();
    _decreaseDirty();
    _decreaseAttention();
    _decreaseSleep();
  }

  void _decreaseHunger() {
    var timer = Timer.periodic(Duration(seconds: 1 + interval), (timer) {
      if (!isSleeping && hungerLevel > 0) {
        hungerLevel = (hungerLevel - 1).clamp(0, 10);
        _hungerController.add(hungerLevel);
        saveNeeds();
      }
    });
    _activeTimers.add(timer);
  }

  void _decreaseDirty() {
    var timer = Timer.periodic(Duration(seconds: 2 + interval), (timer) {
      if (!isSleeping && dirtyLevel > 0) {
        dirtyLevel = (dirtyLevel - 1).clamp(0, 10);
        _dirtyController.add(dirtyLevel);
        saveNeeds();
      }
    });
    _activeTimers.add(timer);
  }

  void _decreaseAttention() {
    var timer = Timer.periodic(Duration(seconds: 3 + interval), (timer) {
      if (!isSleeping && attentionLevel > 0) {
        attentionLevel = (attentionLevel - 1).clamp(0, 10);
        _attentionController.add(attentionLevel);
        saveNeeds();
      }
    });
    _activeTimers.add(timer);
  }

  void _decreaseSleep() {
    Timer.periodic(Duration(seconds: 2 + interval), (timer) {
      if (!isSleeping && sleepLevel > 0) {
        sleepLevel -= 1;
        _sleepController.add(sleepLevel);
        saveNeeds();

        if (sleepLevel == 0) {
          isSleeping = true;
        }
      }
      if (isSleeping) {
        sleepLevel += 1;
        _sleepController.add(sleepLevel);
        saveNeeds();
        if (sleepLevel >= 10) {
          isSleeping = false;
        }
      }
    });
  }

  void updateHungerLevel(int newLevel) {
    hungerLevel = newLevel.clamp(0, 10);
    _hungerController.add(hungerLevel);
    saveNeeds();
  }

  void updateDirtyLevel(int newLevel) {
    dirtyLevel = newLevel.clamp(0, 10);
    _dirtyController.add(dirtyLevel);
    saveNeeds();
  }

  void updateAttentionLevel(int newLevel) {
    attentionLevel = newLevel.clamp(0, 10);
    _attentionController.add(attentionLevel);
    saveNeeds();
  }

  void updateSleepLevel(int newLevel) {
    sleepLevel = newLevel.clamp(0, 10);
    _sleepController.add(sleepLevel);
    saveNeeds();
  }

  void updateSpeedInterval() {
    interval = SpeedSettings.currentInterval;
    print("🚀 Speed setting updated to: ${SpeedSettings.selectedSpeed}");
    print("⏳ New interval: $interval seconds");

    _restartNeedDepletion();
  }

  void _stopAllTimers() {
    for (var timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();
  }

  void _restartNeedDepletion() {
    _stopAllTimers();
    _startNeedDepletion();
  }
}

