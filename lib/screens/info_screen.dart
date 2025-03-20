import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
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
  String apiKey = 'CRkrkhZf3+VMLvelOpFNcQ==bNAFBDe0ZYRnyD2t'; // Replace with your actual API Key

  @override
  void initState() {
    super.initState();
    _loadPetData();
  }

  Future<void> _loadPetData() async {
    await petModel.initPet();
    setState(() => isLoading = false);
  }

  // Function to fetch dog information from the API
  Future<void> _fetchPetFact() async {
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/dogs?name=golden retriever'), // You can modify the breed here
      headers: {'X-Api-Key': apiKey}, // Add your API key in the header
    );

    if (response.statusCode == 200) {
      // If the response is successful, decode the JSON and extract the fact
      final List<dynamic> data = jsonDecode(response.body);
      String fact = "Breed: ${data[0]['name']}\n"
          "Good with children: ${data[0]['good_with_children']}\n"
          "Life expectancy: ${data[0]['min_life_expectancy']} - ${data[0]['max_life_expectancy']} years\n"
          "Shedding: ${data[0]['shedding']}";

      _showPopup("Dog Fact", fact); // Show the result in the popup
    } else {
      // If the API call fails, show an error message
      _showPopup("Error", "Failed to load dog fact.");
    }
  }

  // Function to show the modal popup
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
          OtherButton(
            text: "Animal facts",
            onPressed: _fetchPetFact, // Trigger the fetch function for dog facts
          ),
        ],
      ),
    );
  }
}
