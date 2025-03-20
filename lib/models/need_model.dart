import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class NeedModel {
  int hungerLevel = 10;
  int dirtyLevel = 10;
  int attentionLevel = 10;
  late SharedPreferences prefs;

  final StreamController<int> _hungerController = StreamController<int>.broadcast();
  final StreamController<int> _dirtyController = StreamController<int>.broadcast();
  final StreamController<int> _attentionController = StreamController<int>.broadcast();

  Stream<int> get hungerStream => _hungerController.stream;
  Stream<int> get dirtyStream => _dirtyController.stream;
  Stream<int> get attentionStream => _attentionController.stream;


  String selectedSpeed = "Normal";
  Map<String, int> speedIntervals = {
    "Slow": 100000,
    "Normal": 10000,
    "Fast": 800
  };

  void initNeeds() {
    _hungerController.add(hungerLevel);
    _dirtyController.add(dirtyLevel);
    _attentionController.add(attentionLevel);

    _startNeedDepletion();
  }

  Future<void> loadHungerLevel() async {
    hungerLevel = prefs.getInt('hungerLevel') ?? 10;
    _hungerController.sink.add(hungerLevel);
  }

  Future<void> loadDirtyLevel() async {
    dirtyLevel = prefs.getInt('dirtyLevel') ?? 10;
    _dirtyController.sink.add(dirtyLevel);
  }

  Future<void> loadAttentionLevel() async {
    attentionLevel = prefs.getInt('attentionLevel') ?? 10;
    _attentionController.sink.add(attentionLevel);
  }

  Future<void> saveHungerLevel() async {
    await prefs.setInt('hungerLevel', hungerLevel);
  }

  Future<void> saveDirtyLevel() async {
    await prefs.setInt('dirtyLevel', dirtyLevel);
  }

  Future<void> saveAttentionLevel() async {
    await prefs.setInt('attentionLevel', attentionLevel);
  }

  /// Decrease needs based on speed and multipliers
  void _startNeedDepletion() {
    _decreaseHunger();
    _decreaseDirty();
    _decreaseAttention();
  }

  void _decreaseHunger() {
    Timer.periodic(Duration(milliseconds: speedIntervals[selectedSpeed]!), (timer) {
      if (hungerLevel > 0) {
        hungerLevel -= (1 * 1.55).toInt().clamp(0, 10);
        _hungerController.add(hungerLevel);
      }
    });
  }

  void _decreaseDirty() {
    Timer.periodic(Duration(milliseconds: speedIntervals[selectedSpeed]! + 190), (timer) {
      if (dirtyLevel > 0) {
        dirtyLevel -= (1 * 2).toInt().clamp(0, 10);
        _dirtyController.add(dirtyLevel);
      }
    });
  }

  void _decreaseAttention() {
    Timer.periodic(Duration(milliseconds: speedIntervals[selectedSpeed]! + 66), (timer) {
      if (attentionLevel > 0) {
        attentionLevel -= (1 * 1).toInt().clamp(0, 10);
        _attentionController.add(attentionLevel);
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

  void setSpeed(String newSpeed) {
    if (speedIntervals.containsKey(newSpeed)) {
      selectedSpeed = newSpeed;
    }
  }
}
