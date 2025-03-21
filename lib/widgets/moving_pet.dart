import 'package:flutter/material.dart';
import 'dart:async';

import '../models/need_model.dart';

class MovingPet extends StatefulWidget {
  final NeedModel needModel;
  const MovingPet({super.key, required this.needModel});

  @override
  State<MovingPet> createState() => _MovingPetState();
}

class _MovingPetState extends State<MovingPet> {
  double _position = 0;
  bool _movingRight = true;

  @override
  void initState() {
    super.initState();
    startMoving();
  }

  void startMoving() {
    Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!widget.needModel.isSleeping) {
        setState(() {
          _position = _movingRight ? 200 : 0;
          _movingRight = !_movingRight;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.needModel.isSleeping
        ? Positioned.fill(
      child: Image.asset(
        'assets/images/sleep.png',
        fit: BoxFit.cover,
      ),
    )
        : SizedBox(
      width: double.infinity,
      height: 200,
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(seconds: 15),
            left: _position,
            bottom: 50,
            child: Image.asset(
              _movingRight
                  ? 'assets/images/leftPet.png'
                  : 'assets/images/rightPet.png',
              width: 100,
            ),
          ),
        ],
      ),
    );
  }
}
