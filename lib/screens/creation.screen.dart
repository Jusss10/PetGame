import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../widgets/navigation_bar.dart';

class PetCreationScreen extends StatefulWidget {
  const PetCreationScreen({super.key});

  @override
  State<PetCreationScreen> createState() => _PetCreationScreenState();
}

class _PetCreationScreenState extends State<PetCreationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final PetModel _petModel = PetModel();

  @override
  void initState() {
    super.initState();
    _petModel.initPet();
  }

  Future<void> _savePet() async {
    String petName = _nameController.text.trim();
    if (petName.isNotEmpty) {
      await _petModel.savePet(petName);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainNavigationBar()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Your Pet")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Pet Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePet,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
