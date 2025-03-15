import 'package:flutter/material.dart';
import 'package:pet_game/widgets/custom_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String petStatus = "null";

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(petStatus, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            CustomButton(icon: Icons.fastfood, onPressed: feedPet),
            CustomButton(icon: Icons.bathtub, onPressed: bathPet),
            CustomButton(icon: Icons.pets, onPressed: cuddlePet),
          ],
        ),
      ),
    );
  }
}
