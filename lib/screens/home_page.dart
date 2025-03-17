import 'package:flutter/material.dart';
import 'package:pet_game/widgets/custom_button.dart';
import 'package:pet_game/widgets/custom_container.dart';
import 'package:pet_game/models/hunger_model.dart'; // Import HungerModel

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String petStatus = " ";
  final HungerModel hungerModel = HungerModel(); // Instantiate HungerModel

  @override
  void initState() {
    super.initState();
    hungerModel.init(); // Initialize the hunger model
    hungerModel.decreaseHungerPeriodically(); // Optionally, start the periodic hunger decrease
  }

  void feedPet() {
    setState(() {
      petStatus = "mmmhhh delicious";
    });
    hungerModel.updateHungerLevel(hungerModel.hungerLevel + 2); // Increase hunger level
  }

  void bathPet() {
    setState(() {
      petStatus = "Now im clean!!";
    });
  }

  void cuddlePet() {
    setState(() {
      petStatus = "I feel loved, thank u";
    });
  }

  void reset() {
    setState(() {
      petStatus = "reset";
    });
    hungerModel.resetHunger();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: CustomContainer(
              icon: Icons.fastfood,
              hungerModel: hungerModel,
            ),
          ),
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
                    CustomButton(icon: Icons.reset_tv_outlined, onPressed: reset),
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
