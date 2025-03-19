import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class PetModel {
  late SharedPreferences prefs;
  String petName = '';
  String petGender = '';

  Future<void> initPet() async {
    prefs = await SharedPreferences.getInstance();
    petName = prefs.getString('petName') ?? '';
    petGender = prefs.getString('petGender') ?? _getRandomGender();
  }

  String _getRandomGender() => Random().nextBool() ? "Male" : "Female";

  Future<void> savePet(String name) async {
    await _ensurePrefsInitialized();
    petName = name;
    petGender = _getRandomGender();
    await prefs.setString('petName', petName);
    await prefs.setString('petGender', petGender);
  }

  Future<void> resetPet() async {
    await _ensurePrefsInitialized(); // Make sure prefs is available before using it
    await prefs.clear();
  }

  Future<void> _ensurePrefsInitialized() async {
    if (!prefsInitialized) {
      prefs = await SharedPreferences.getInstance();
      prefsInitialized = true;
    }
  }

  bool prefsInitialized = false;
}
