import 'package:shared_preferences/shared_preferences.dart';
import '../models/need_model.dart';

class SpeedSettings {
  static const Map<String, int> speedIntervals = {
    "Slow": 2,
    "Normal": 10,
    "Fast": 0
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

    // Notify NeedModel to update immediately
    NeedModel().updateSpeedInterval();
  }

  static int get currentInterval => speedIntervals[selectedSpeed] ?? 10;
}
