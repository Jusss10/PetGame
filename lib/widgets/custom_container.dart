import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  final Stream<int> needStream;

  const CustomContainer({super.key, required this.icon, required this.needStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: needStream,
      builder: (context, snapshot) {
        // Error handling
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
        }

        // Default waarde als er geen data is (bijv. tijdens wachten)
        int needLevel = snapshot.data ?? 10;

        return Column(
          children: [
            Icon(icon, color: Colors.green, size: 30),
            const SizedBox(height: 5),

            // Progress Bar
            Container(
              width: 50,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: FractionallySizedBox(
                widthFactor: needLevel.clamp(0, 10) / 10, // Zorgt ervoor dat de waarde tussen 0-10 blijft
                alignment: Alignment.centerLeft,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
