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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pet Information")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
          mainAxisAlignment:  MainAxisAlignment.center,
          children: [
            Text('Pet Name: ${petModel.petName}',
                style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 10),
            Text('Pet Gender: ${petModel.petGender}',
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
