import 'package:flutter/material.dart';
import 'dart:async';

class MovingPet extends StatefulWidget {
  const MovingPet({super.key});

  @override
  State<MovingPet> createState() => _MovingPetState();
}

class _MovingPetState extends State<MovingPet>{
  double _position = 0; // X-axis position
  bool _movingRight = true; // Direction control

  @override
  void initState() {
    super.initState();
    startMoving(); // Start movement when widget is created
  }

  void startMoving() {
    Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _position = _movingRight ? 200 : 0; // Move left or right
        _movingRight = !_movingRight; // Toggle direction
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(seconds: 1),
          left: _position,
          bottom: 50,
          child: Image.asset('assets/rightPet.png', width: 100),
        ),
      ],
    );
  }
}