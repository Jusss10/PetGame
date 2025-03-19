import 'package:flutter/material.dart';
import '../models/pet_model.dart';

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
    setState(() {
      isLoading = false;
    });
  }

  void showFullScreenPopup(String title, Widget content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: content,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Close"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showPetInfo() {
    showFullScreenPopup(
      "Pet Info",
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pet Name: ${petModel.petName}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text('Pet Gender: ${petModel.petGender}', style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          const Text(
            "Take good care of your pet. "
                "\nOtherwise it wont be happy with u",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void showCredits() {
    showFullScreenPopup(
      "Credits",
      const Text(
        "Justine Dor made the game"
            "\nThanks to everyone who contributed.",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  void showHowToPlay() {
    showFullScreenPopup(
      "How to Play",
      const Text(
        "Feed your pet, Bath your pet and give your pet somme attention",
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: Text(text),
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
          buildButton("Pet Info", showPetInfo),
          buildButton("Credits", showCredits),
          buildButton("How to Play", showHowToPlay),
        ],
      ),
    );
  }
}
