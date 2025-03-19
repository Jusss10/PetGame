import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class PetModel {
  late String petName;
  late String petGender;
  late SharedPreferences prefs;

  Future<void> initPet() async {
    prefs = await SharedPreferences.getInstance();
    petName = prefs.getString('petName') ?? '';
    petGender = prefs.getString('petGender') ?? _getRandomGender();
  }

  String _getRandomGender() => Random().nextBool() ? "Male" : "Female";

  Future<void> savePet(String name) async {
    petName = name;
    petGender = _getRandomGender();
    await prefs.setString('petName', petName);
    await prefs.setString('petGender', petGender);
  }
}
