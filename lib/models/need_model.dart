import 'dart:async';
import 'package:pet_game/models/speed_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NeedModel {
  int hungerLevel = 10;
  int dirtyLevel = 10;
  int attentionLevel = 10;
  int sleepLevel = 10;

  late Timer _needTimer;

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

  String selectedSpeed = "Normal";
  Map<String, double> speedIntervals = {
    "Slow": 0.9,
    "Normal": 1.4,
    "Fast": 2
  };

  void initNeeds() {
    _hungerController.add(hungerLevel);
    _dirtyController.add(dirtyLevel);
    _attentionController.add(attentionLevel);
    _sleepController.add(sleepLevel);

    _startNeedTimer();
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

  void _startNeedTimer() {
    _needTimer = Timer.periodic(Duration(milliseconds: SpeedSettings.currentInterval), (timer) {
      _startNeedDepletion();
    });
  }

  void _restartNeedTimer() {
    _needTimer.cancel();
    _startNeedTimer();
  }

  /// Starts decreasing needs over time
  void _startNeedDepletion() {
    _decreaseHunger();
    _decreaseDirty();
    _decreaseAttention();
    _decreaseSleep();
  }

  void _decreaseHunger() {
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      if (!isSleeping && hungerLevel > 0) {
        hungerLevel -= (1 * speedIntervals[selectedSpeed]!).toInt().clamp(0, 10);
        _hungerController.add(hungerLevel);
      }
    });
  }

  void _decreaseDirty() {
    Timer.periodic(Duration(milliseconds: 800 + 190), (timer) {
      if (!isSleeping && dirtyLevel > 0) {
        dirtyLevel -= (1 * speedIntervals[selectedSpeed]!).toInt().clamp(0, 10);
        _dirtyController.add(dirtyLevel);
      }
    });
  }

  void _decreaseAttention() {
    Timer.periodic(Duration(milliseconds: 1800 + 66), (timer) {
      if (!isSleeping && attentionLevel > 0) {
        attentionLevel -= (1 * speedIntervals[selectedSpeed]!).toInt().clamp(0, 10);
        _attentionController.add(attentionLevel);
      }
    });
  }

  void _decreaseSleep() {
    Timer.periodic(Duration(milliseconds: 1800 + 300), (timer) {
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
    print("Attention Level Updated: $hungerLevel"); // Debugging
  }

  void updateDirtyLevel(int newLevel) {
    dirtyLevel = newLevel.clamp(0, 10);
    _dirtyController.add(dirtyLevel);
    print("Attention Level Updated: $dirtyLevel"); // Debugging
  }

  void updateAttentionLevel(int newLevel) {
    attentionLevel = newLevel.clamp(0, 10);
    _attentionController.add(attentionLevel);
    print("Attention Level Updated: $attentionLevel"); // Debugging
  }


  void updateSleepLevel(int newLevel) {
    sleepLevel = newLevel.clamp(0, 10);
    _sleepController.add(sleepLevel);
  }

  void setSpeed(String newSpeed) {
    if (speedIntervals.containsKey(newSpeed)) {
      selectedSpeed = newSpeed;
    }
  }

}

