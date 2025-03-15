import 'package:shared_preferences/shared_preferences.dart';

class HungerModel {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  int hungerLevel = 100; // Default hunger level

  // Initialize SharedPreferencesAsync
  Future<void> init() async {
    await loadHungerLevel();
  }

  // Load hunger level from storage
  Future<void> loadHungerLevel() async {
    hungerLevel = await prefs.getInt('hungerLevel') ?? 100;
  }

  // Save hunger level to storage
  Future<void> saveHungerLevel() async {
    await prefs.setInt('hungerLevel', hungerLevel);
  }

  // Update hunger level and save
  Future<void> updateHungerLevel(int newLevel) async {
    hungerLevel = newLevel;
    await saveHungerLevel();
  }

  // Decrease hunger periodically
  void decreaseHungerPeriodically() {
    Future.delayed(const Duration(seconds: 10), () async {
      if (hungerLevel > 0) {
        hungerLevel--;
        await saveHungerLevel();
      }
      decreaseHungerPeriodically(); // Keep it running
    });
  }
}
//Future<void> : represents an asynchronous operation
//prefs stores key(hungerLevel) and value(int)
