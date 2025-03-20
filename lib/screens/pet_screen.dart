import 'package:flutter/material.dart';
import 'package:pet_game/widgets/custom_button.dart';
import 'package:pet_game/widgets/custom_container.dart';
import '../models/need_model.dart';
import 'package:audioplayers/audioplayers.dart';

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  String petStatus = " ";
  final NeedModel needModel = NeedModel();
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    needModel.initNeeds();
    player = AudioPlayer();
  }

  void updatePetStatus(String newStatus) {
    setState(() {
      petStatus = newStatus;
    });
  }

  void feedPet() {
    if (needModel.hungerLevel == 10) {
      updatePetStatus("I'm full, please stop feeding me.");
    } else {
      updatePetStatus("Mmmhhh delicious!");
      player.play(AssetSource('audio/foodSound.wav'));
      needModel.updateHungerLevel(needModel.hungerLevel + 2);
    }
  }

  void bathPet() {
    if (needModel.dirtyLevel == 10) {
      updatePetStatus("I'm not stinking anymore, so stop.");
    } else {
      updatePetStatus("Now I'm clean!!");
      player.play(AssetSource('audio/bathSound.wav'));
      needModel.updateDirtyLevel(needModel.dirtyLevel + 2);
    }
  }

  void cuddlePet() {
    if (needModel.attentionLevel == 10) {
      updatePetStatus("Can I please get some alone time? Thanks.");
    } else {
      updatePetStatus("I feel loved, thank you!");
      player.play(AssetSource('audio/attentionSound.wav'));
      needModel.updateAttentionLevel(needModel.attentionLevel + 2);
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
                    needStream: needModel.hungerStream,
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    icon: Icons.bathtub,
                    needStream: needModel.dirtyStream,
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    icon: Icons.favorite,
                    needStream: needModel.attentionStream,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
