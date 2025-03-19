import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import 'creation.screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Settings Screen', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await PetModel().resetPet();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PetCreationScreen()),
                );
              }
            },
            child: const Text('Reset Pet'),
          ),
        ],
      ),
    );
  }
}
