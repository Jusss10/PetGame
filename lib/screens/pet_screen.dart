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
  final NeedModel needModel = NeedModel(); // initialize need models
  late AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    needModel.initNeeds(); // initialize need models

    ///starting all decreases for needs ///
    needModel.decreaseHungerPeriodically();
    needModel.decreaseDirtyPeriodically();
    needModel.decreaseAttentionPeriodically();

    player = AudioPlayer();
  }

  void feedPet() {
    if(needModel.hungerLevel == 10) {
      setState(() {
        petStatus = "Im full, please stop feeding me";
      });
    } else {
      setState(() {
        petStatus = "mmmhhh delicious";
      });
      player.play(AssetSource('audio/foodSound.wav'));
      needModel.updateHungerLevel(needModel.hungerLevel + 2);
    }
  }

  void bathPet() {
    if(needModel.dirtyLevel == 10) {
      setState(() {
        petStatus = "Im not stinking anymore, so stop";
      });
    } else {
      setState(() {
        petStatus = "Now im clean!!";
      });
      player.play(AssetSource('audio/bathSound.wav'));
      needModel.updateDirtyLevel(needModel.dirtyLevel + 2);
    }
  }

  void cuddlePet() {
    if(needModel.attentionLevel == 10) {
      setState(() {
        petStatus = "Can i please get some alone time, thanks";
      });
    } else {
      setState(() {
        petStatus = "I feel loved, thank u";
      });
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
          // Needs Row (Displays the needs horizontally at the top)
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
                    icon: Icons.bedtime,
                    needStream: needModel.attentionStream,
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    icon: Icons.pets,
                    needStream: needModel.attentionStream,
                  ),
                ),
                Expanded(
                  child: CustomContainer(
                    icon: Icons.emoji_emotions,
                    needStream: needModel.attentionStream,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Pet status text
          Text(petStatus, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 20),

          // Buttons Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(icon: Icons.fastfood, onPressed: feedPet),
              CustomButton(icon: Icons.bathtub, onPressed: bathPet),
              CustomButton(icon: Icons.pets, onPressed: cuddlePet),
            ],
          ),
        ],
      ),
    );
  }
}
