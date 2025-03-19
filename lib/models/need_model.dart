import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class NeedModel {
  int hungerLevel = 10;
  int dirtyLevel = 10;
  int attentionLevel = 10;
  late SharedPreferences prefs; // initialize later

  final StreamController<int> _hungerController = StreamController<int>();
  Stream<int> get hungerStream => _hungerController.stream;

  final StreamController<int> _dirtyController = StreamController<int>();
  Stream<int> get dirtyStream => _dirtyController.stream;

  final StreamController<int> _attentionController = StreamController<int>();
  Stream<int> get attentionStream => _attentionController.stream;

  // Initialize SharedPreferences
  Future<void> initNeeds() async {
    prefs = await SharedPreferences.getInstance();
    await loadHungerLevel();
    await loadDirtyLevel();
    await loadAttentionLevel();
  }


  /// loading from storage and notify listeners ///
  Future<void> loadHungerLevel() async {
    hungerLevel = prefs.getInt('hungerLevel') ?? 10;
    _hungerController.sink.add(hungerLevel); // Notify listeners
  }
  Future<void> loadDirtyLevel() async {
    dirtyLevel = prefs.getInt('dirtyLevel') ?? 10;
    _dirtyController.sink.add(dirtyLevel); // Notify listeners
  }
  Future<void> loadAttentionLevel() async {
    attentionLevel = prefs.getInt('attentionLevel') ?? 10;
    _attentionController.sink.add(attentionLevel); // Notify listeners
  }


  /// Save to storage ///
  Future<void> saveHungerLevel() async {
    await prefs.setInt('hungerLevel', hungerLevel);
  }
  Future<void> saveDirtyLevel() async {
    await prefs.setInt('dirtyLevel', dirtyLevel);
  }
  Future<void> saveAttentionLevel() async {
    await prefs.setInt('attentionLevel', attentionLevel);
  }


  /// Update, save, and notify listeners ///
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


  /// Decrease periodically and notify listeners ///
  void decreaseHungerPeriodically() {
    Future.delayed(const Duration(seconds: 104), () async {
      if (hungerLevel > 0) {
        hungerLevel--;
        await saveHungerLevel();
        _hungerController.sink.add(hungerLevel);
      }
      decreaseHungerPeriodically(); // Keep running
    });
  }
  void decreaseDirtyPeriodically() {
    Future.delayed(const Duration(seconds: 98), () async {
      if (dirtyLevel > 0) {
        dirtyLevel--;
        await saveDirtyLevel();
        _dirtyController.sink.add(dirtyLevel);
      }
      decreaseDirtyPeriodically(); // Keep running
    });
  }
  void decreaseAttentionPeriodically() {
    Future.delayed(const Duration(seconds: 67), () async {
      if (attentionLevel > 0) {
        attentionLevel--;
        await saveAttentionLevel();
        _attentionController.sink.add(attentionLevel);
      }
      decreaseAttentionPeriodically(); // Keep running
    });
  }


  /// Dispose of streams ///
  void dispose() {
    _hungerController.close();
    _dirtyController.close();
    _attentionController.close();
  }
}
