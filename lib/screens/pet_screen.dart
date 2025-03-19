import 'package:flutter/material.dart';
import 'package:pet_game/widgets/custom_button.dart';
import 'package:pet_game/widgets/custom_container.dart';
import '../models/need_model.dart';


class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends State<PetScreen> {
  String petStatus = " ";
  final NeedModel needModel = NeedModel(); // initialize need models

  @override
  void initState() {
    super.initState();
    needModel.initNeeds(); // initialize need models
    ///starting all decreases for needs ///
    needModel.decreaseHungerPeriodically();
    needModel.decreaseDirtyPeriodically();
    needModel.decreaseAttentionPeriodically();
  }

  void feedPet() {
    setState(() {
      petStatus = "mmmhhh delicious";
    });
    needModel.updateHungerLevel(
        needModel.hungerLevel + 2); // increase hunger level
  }

  void bathPet() {
    setState(() {
      petStatus = "Now im clean!!";
    });
    needModel.updateDirtyLevel(needModel.dirtyLevel + 2);
  }

  void cuddlePet() {
    setState(() {
      petStatus = "I feel loved, thank u";
    });
    needModel.updateAttentionLevel(needModel.attentionLevel + 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: Column( //now it vertically
        children: [
          CustomContainer(
            icon: Icons.fastfood,
            needStream: needModel.hungerStream,
          ),
          const SizedBox(height: 5),
          CustomContainer(
            icon: Icons.bathtub,
            needStream: needModel.dirtyStream,
          ),
          const SizedBox(height: 5),
          CustomContainer(
            icon: Icons.pets,
            needStream: needModel.attentionStream,
          ),
          const SizedBox(height: 100),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 200),
                Text(petStatus, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
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
          ),
        ],
      ),
    );
  }
}
