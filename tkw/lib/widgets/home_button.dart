import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Horizontal Line
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.blueAccent, // Line color
        ),
        // Circular icon with image
        Container(
          decoration: BoxDecoration(
            color: Colors.white, // Background color
            shape: BoxShape.circle,
            border: Border.all(color: Colors.blueAccent, width: 1),
          ),
          padding: const EdgeInsets.all(8),
          child: IconButton(
            onPressed: () {

              Navigator.pop(context);
            },
            icon: Image.asset(
              'assets/images/home.png',
              width: 36,
              height: 36,
            ),
          ),
        ),
      ],
    );
  }
}
