import 'package:flutter/material.dart';
import 'dart:async';

class MovingPet extends StatefulWidget {
  const MovingPet({super.key});

  @override
  State<MovingPet> createState() => _MovingPetState();
}

class _MovingPetState extends State<MovingPet>{
  double _position = 0;
  bool _movingRight = true;

  @override
  void initState() {
    super.initState();
    startMoving();
  }

  void startMoving() {
    Timer.periodic(const Duration(seconds: 15), (timer) {
      setState(() {
        _position = _movingRight ? 200 : 0;
        _movingRight = !_movingRight;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 150,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 15),
            left: _position,
            bottom: 50,
            child: Image.asset('assets/images/rightPet.png', width: 100),
          ),
        ],
      ),
    );
  }
}