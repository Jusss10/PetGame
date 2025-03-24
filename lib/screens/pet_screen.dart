import 'package:flutter/material.dart';
import 'package:pet_game/widgets/custom_button.dart';
import 'package:pet_game/widgets/custom_container.dart';
import 'package:pet_game/widgets/moving_pet.dart';
import '../models/need_model.dart';
import 'package:audioplayers/audioplayers.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  String petStatus = " ";
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _initializeNeeds();
  }

  Future<void> _initializeNeeds() async {
    await NeedModel().loadNeeds();
    setState(() {}); // Update the UI after loading
    NeedModel().initNeeds(); // Start only after loading data
  }

  void updatePetStatus(String newStatus) {
    setState(() {
      petStatus = newStatus;
    });
  }

  void feedPet() {
    if (NeedModel().hungerLevel == 10) {
      updatePetStatus("I'm full, please stop feeding me.");
    } else if (NeedModel().isSleeping) {
      updatePetStatus("I'm sleeping");
    } else {
      updatePetStatus("Mmmhhh delicious!");
      player.play(AssetSource('audio/foodSound.wav'));
      NeedModel().updateHungerLevel(NeedModel().hungerLevel + 2);
    }
  }

  void bathPet() {
    if (NeedModel().dirtyLevel == 10) {
      updatePetStatus("I'm not stinking anymore, so stop.");
    } else if (NeedModel().isSleeping) {
      updatePetStatus("I'm sleeping");
    } else {
      updatePetStatus("Now I'm clean!!");
      player.play(AssetSource('audio/bathSound.wav'));
      NeedModel().updateDirtyLevel(NeedModel().dirtyLevel + 2);
    }
  }

  void cuddlePet() {
    if (NeedModel().attentionLevel == 10) {
      updatePetStatus("Can I please get some alone time? Thanks.");
    } else if (NeedModel().isSleeping) {
      updatePetStatus("I'm sleeping");
    } else {
      updatePetStatus("I feel loved, thank you!");
      player.play(AssetSource('audio/attentionSound.wav'));
      NeedModel().updateAttentionLevel(NeedModel().attentionLevel + 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: CustomContainer(
                    icon: Icons.fastfood,
                    needStream: NeedModel().hungerStream,
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    icon: Icons.bathtub,
                    needStream: NeedModel().dirtyStream,
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    icon: Icons.favorite,
                    needStream: NeedModel().attentionStream,
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    icon: Icons.bedtime,
                    needStream: NeedModel().sleepStream,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pet Moving
          const MovingPet(), // Removed the needModel parameter

          // Pet Status
          Text(petStatus, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(icon: Icons.fastfood, onPressed: feedPet),
              CustomButton(icon: Icons.bathtub, onPressed: bathPet),
              CustomButton(icon: Icons.favorite, onPressed: cuddlePet),
            ],
          ),
        ],
      ),
    );
  }
}
