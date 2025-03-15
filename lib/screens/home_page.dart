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
      petStatus = "Your pet is eating!";
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
          ],
        ),
      ),
    );
  }
}
