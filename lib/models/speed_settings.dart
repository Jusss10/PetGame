import 'package:shared_preferences/shared_preferences.dart';

class SpeedSettings {
  static const Map<String, int> speedIntervals = {
    "Slow": 2,  // 3 seconds
    "Normal": 10,  // 1.5 seconds
    "Fast": 0  // 0.75 seconds
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

  // Get the interval for the current selected speed
  static int get currentInterval => speedIntervals[selectedSpeed] ?? 1500;
}
