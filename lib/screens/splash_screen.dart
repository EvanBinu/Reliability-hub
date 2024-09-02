import 'package:flutter/material.dart';
import '../home.dart'; // Ensure that 'home.dart' contains the correct class name 'Home'

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to the Home screen after a delay
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFE3FEF7), // Background color
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/data-transfer.png', // Replace with your image asset path
              width: 150, // Adjust the width of the image
              height: 150, // Adjust the height of the image
            ),
            const SizedBox(height: 20), // Space between the image and the text
            const Text(
              'Reliability Hub',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Color(0xFF135D66), // Optional: Match the app theme color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
