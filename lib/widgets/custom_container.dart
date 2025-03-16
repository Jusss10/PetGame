import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final IconData icon;
  const CustomContainer({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8), // Padding around the icon
          child: Icon(icon, color: Colors.green, size: 25),
        ),
        const SizedBox(width: 8), // Space between icon and bar
        Container(

        ),
      ],
    );
  }


}