import 'package:flutter/material.dart';
import 'package:pet_game/models/hunger_model.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  final HungerModel hungerModel;

  const CustomContainer({super.key, required this.icon, required this.hungerModel});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: hungerModel.hungerStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        int hungerLevel = snapshot.data ?? 10;

        return Container(
          padding: const EdgeInsets.all(8),
          color: Colors.black,
          child: Row(
            children: [
              Icon(icon, color: Colors.green, size: 25),
              const SizedBox(width: 8),
              Container(
                width: 100,
                height: 10,
                color: Colors.grey,
                child: Row(
                  children: List.generate( hungerLevel, (index) =>
                  Container(
                      width: 10,
                      height: 10,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
