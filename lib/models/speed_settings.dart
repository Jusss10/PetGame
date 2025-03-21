import 'package:shared_preferences/shared_preferences.dart';

class SpeedSettings {
  static Map<String, int> speedIntervals = {
    "Slow": 3000,
    "Normal": 1500,
    "Fast": 750
  };

  static String selectedSpeed = "Normal";
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
