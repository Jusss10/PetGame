import 'package:shared_preferences/shared_preferences.dart';
import '../models/need_model.dart';

class SpeedSettings {
  static const Map<String, int> speedIntervals = {
    "Slow": 2,
    "Normal": 10,
    "Fast": 0
  };

  static String _selectedSpeed = "Normal";

  static Future<void> loadSpeedSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedSpeed = prefs.getString('selectedSpeed') ?? "Normal";
    print("🔄 Speed setting loaded: $_selectedSpeed");

    // Ensure NeedModel gets updated even on app restart
    NeedModel().updateSpeedInterval();
  }


  static Future<void> saveSpeedSetting(String speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSpeed', speed);
    _selectedSpeed = speed;

    print("✅ Speed setting saved: $_selectedSpeed"); // Debug log

    // Notify NeedModel singleton to update immediately
    NeedModel().updateSpeedInterval();
  }

  static int get currentInterval {
    print("⏳ Current interval: ${speedIntervals[_selectedSpeed] ?? 10} seconds"); // Debug log
    return speedIntervals[_selectedSpeed] ?? 10;
  }

  static String get selectedSpeed => _selectedSpeed;
}
