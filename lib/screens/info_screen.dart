import 'package:flutter/material.dart';
import '../models/pet_model.dart';
import '../widgets/other_button.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  final PetModel petModel = PetModel();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    await petModel.initPet();
    setState(() => isLoading = false);
  }

  void _showPopup(String title, String message) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Divider(),
            Text(message, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Information")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OtherButton(
            text: "Pet Info",
            onPressed: () => _showPopup("Pet Info", "Pet Name: ${petModel.petName}\nPet Gender: ${petModel.petGender}\n\nTake good care of your pet!"),
          ),
          OtherButton(
            text: "Credits",
            onPressed: () => _showPopup("Credits", "Justine Dor made the game\nThanks to everyone who contributed."),
          ),
          OtherButton(
            text: "How to Play",
            onPressed: () => _showPopup("How to Play", "Feed your pet, bathe it, and give it attention."),
          ),
        ],
      ),
    );
  }
}
