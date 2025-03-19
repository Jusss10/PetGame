import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  final Stream<int> needStream; //make a globalStream

  const CustomContainer({super.key, required this.icon, required this.needStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: needStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        int needLevel = snapshot.data ?? 10;

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
                  children: List.generate(needLevel, (index) =>
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
