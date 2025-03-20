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

        return Column(
          children: [
            Icon(icon, color: Colors.green, size: 30),
            const SizedBox(height: 5),

            Container(//progress bar
              width: 50,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),

              child: Container(// progressbar itself
                width: 50,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey[300], // empty bar
                  borderRadius: BorderRadius.circular(5),
                ),

                child: Stack(
                  children: [
                    Container(
                      width: 50,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),

                    FractionallySizedBox(//filling of bar
                      widthFactor: needLevel / 10,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ],
        );
      },
    );
  }
}
