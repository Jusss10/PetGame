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
    "Slow": 150,
    "Normal": 100,
    "Fast": 50
  };

  Future<void> initNeeds() async {
    prefs = await SharedPreferences.getInstance();
    selectedSpeed = prefs.getString('selectedSpeed') ?? "Normal";

    await loadHungerLevel();
    await loadDirtyLevel();
    await loadAttentionLevel();

    startDecreaseTimers();
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

  Future<void> updateHungerLevel(int newLevel) async {
    hungerLevel = newLevel.clamp(0, 10);
    await saveHungerLevel();
    _hungerController.sink.add(hungerLevel);
  }

  Future<void> updateDirtyLevel(int newLevel) async {
    dirtyLevel = newLevel.clamp(0, 10);
    await saveDirtyLevel();
    _dirtyController.sink.add(dirtyLevel);
  }

  Future<void> updateAttentionLevel(int newLevel) async {
    attentionLevel = newLevel.clamp(0, 10);
    await saveAttentionLevel();
    _attentionController.sink.add(attentionLevel);
  }

  /// Decrease needs based on selected speed ///
  void startDecreaseTimers() {
    decreaseHungerPeriodically();
    decreaseDirtyPeriodically();
    decreaseAttentionPeriodically();
  }

  void decreaseHungerPeriodically() {
    Future.delayed(Duration(seconds: speedIntervals[selectedSpeed]!), () async {
      if (hungerLevel > 0) {
        hungerLevel--;
        await saveHungerLevel();
        _hungerController.sink.add(hungerLevel);
      }
      decreaseHungerPeriodically();
    });
  }

  void decreaseDirtyPeriodically() {
    Future.delayed(Duration(seconds: speedIntervals[selectedSpeed]!), () async {
      if (dirtyLevel > 0) {
        dirtyLevel--;
        await saveDirtyLevel();
        _dirtyController.sink.add(dirtyLevel);
      }
      decreaseDirtyPeriodically();
    });
  }

  void decreaseAttentionPeriodically() {
    Future.delayed(Duration(seconds: speedIntervals[selectedSpeed]!), () async {
      if (attentionLevel > 0) {
        attentionLevel--;
        await saveAttentionLevel();
        _attentionController.sink.add(attentionLevel);
      }
      decreaseAttentionPeriodically();
    });
  }

  Future<void> updateSpeed(String newSpeed) async {
    selectedSpeed = newSpeed;
    await prefs.setString('selectedSpeed', newSpeed);
    startDecreaseTimers();
  }

  void dispose() {
    _hungerController.close();
    _dirtyController.close();
    _attentionController.close();
  }
}
