import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class HungerModel {
  int hungerLevel = 100; // Default hunger level
  late SharedPreferences prefs; // Initialize later

  final StreamController<int> _hungerController = StreamController<int>();
  Stream<int> get hungerStream => _hungerController.stream;

  // Initialize SharedPreferences
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    await loadHungerLevel();
  }

  // Load hunger level from storage and notify listeners
  Future<void> loadHungerLevel() async {
    hungerLevel = prefs.getInt('hungerLevel') ?? 100;
    _hungerController.sink.add(hungerLevel); // Notify listeners
  }

  // Save hunger level to storage
  Future<void> saveHungerLevel() async {
    await prefs.setInt('hungerLevel', hungerLevel);
  }

  // Update hunger level, save, and notify listeners
  Future<void> updateHungerLevel(int newLevel) async {
    hungerLevel = newLevel;
    await saveHungerLevel();
    _hungerController.sink.add(hungerLevel);
  }

  // Decrease hunger periodically and notify listeners
  void decreaseHungerPeriodically() {
    Future.delayed(const Duration(seconds: 10), () async {
      if (hungerLevel > 0) {
        hungerLevel--;
        await saveHungerLevel();
        _hungerController.sink.add(hungerLevel);
      }
      decreaseHungerPeriodically(); // Keep running
    });
  }

  // Dispose of the stream
  void dispose() {
    _hungerController.close();
  }
}
