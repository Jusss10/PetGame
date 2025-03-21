import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../models/speed_settings.dart';
import '../widgets/other_button.dart';
import 'creation.screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadSpeedSetting();
  }

  Future<void> _loadSpeedSetting() async {
    await SpeedSettings.loadSpeedSetting();
    setState(() {});
  }

  Future<void> _saveSpeedSetting(String speed) async {
    await SpeedSettings.saveSpeedSetting(speed);
    setState(() {});
  }

  void _showSpeedSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SpeedSettingsModal(
        selectedSpeed: SpeedSettings.selectedSpeed,
        onSpeedSelected: (speed) async {
          await _saveSpeedSetting(speed);
        },
      ),
    );
  }

  Future<void> _resetPet() async {
    await PetModel().resetPet();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PetCreationScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtherButton(text: "Change Decrease Rate", onPressed: _showSpeedSettings),
          OtherButton(text: "Reset Pet", onPressed: _resetPet),
        ],
      ),
    );
  }
}

class SpeedSettingsModal extends StatelessWidget {
  final String selectedSpeed;
  final ValueChanged<String> onSpeedSelected;

  const SpeedSettingsModal({
    super.key,
    required this.selectedSpeed,
    required this.onSpeedSelected,
  });

  @override
  Widget build(BuildContext context) {
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
          _buildRadioButton(context, "Slow", "Slow (Needs decrease slowly)"),
          _buildRadioButton(context, "Normal", "Normal (Default speed)"),
          _buildRadioButton(context, "Fast", "Fast (Needs decrease quickly)"),
          const SizedBox(height: 20),
          OtherButton(text: "Close", onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Widget _buildRadioButton(BuildContext context, String value, String text) {
    return RadioListTile<String>(
      title: Text(text),
      value: value,
      groupValue: selectedSpeed,
      onChanged: (newValue) {
        if (newValue != null) {
          onSpeedSelected(newValue);
        }
        Navigator.pop(context);
      },
    );
  }
}
