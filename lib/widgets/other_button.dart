import 'package:flutter/material.dart';

class OtherButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const OtherButton({super.key, required this.text, required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 70,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            textStyle: const TextStyle(fontSize: 20),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
