import 'package:flutter/material.dart';
import 'package:pet_game/widgets/custom_button.dart';
import 'package:pet_game/widgets/custom_container.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String petStatus = " ";

  void feedPet() {
    setState(() {
      petStatus = "mmmhhh delicious";
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 20, // Distance from the top
            child: CustomContainer(icon: Icons.fastfood),
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
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }
}
