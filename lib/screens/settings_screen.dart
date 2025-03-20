import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pet_model.dart';
import '../widgets/other_button.dart';
import 'creation.screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedSpeed = "Normal";

  @override
  void initState() {
    super.initState();
    _loadSpeedSetting();
  }

  Future<void> _loadSpeedSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedSpeed = prefs.getString('selectedSpeed') ?? "Normal";
    });
  }

  Future<void> _saveSpeedSetting(String speed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedSpeed', speed);
  }

  void _showSpeedSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Change Decrease Rate",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              _buildRadioButton("Slow", "Slow (Needs decrease slowly)"),
              _buildRadioButton("Normal", "Normal (Default speed)"),
              _buildRadioButton("Fast", "Fast (Needs decrease quickly)"),
              const SizedBox(height: 20),
              OtherButton(text: "Close", onPressed: () => Navigator.pop(context)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRadioButton(String value, String text) {
    return RadioListTile<String>(
      title: Text(text),
      value: value,
      groupValue: selectedSpeed,
      onChanged: (newValue) {
        if (newValue != null) {
          setState(() {
            selectedSpeed = newValue;
          });
          _saveSpeedSetting(newValue);
        }
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtherButton(text: "Change Decrease Rate", onPressed: _showSpeedSettings),
          OtherButton(
            text: "Reset Pet",
            onPressed: () async {
              await PetModel().resetPet();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PetCreationScreen()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
