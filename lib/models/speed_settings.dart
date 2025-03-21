import 'package:shared_preferences/shared_preferences.dart';

class SpeedSettings {
  static Map<String, int> speedIntervals = {
    "Slow": 3000,   // Slower depletion (3 sec per tick)
    "Normal": 1500, // Normal depletion (1.5 sec per tick)
    "Fast": 750     // Faster depletion (0.75 sec per tick)
  };

  static String selectedSpeed = "Normal"; // Default value

  static Future<void> loadSpeedSetting() async {
    final prefs = await SharedPreferences.getInstance();
    selectedSpeed = prefs.getString('selectedSpeed') ?? "Normal";
  }

  static Future<void> saveSpeedSetting(String speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSpeed', speed);
    selectedSpeed = speed;
  }

  static int get currentInterval => speedIntervals[selectedSpeed] ?? 1500;
}
