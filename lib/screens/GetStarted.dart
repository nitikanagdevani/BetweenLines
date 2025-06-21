import 'package:flutter/material.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.lightBlue[50], // Light background color
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'BetweenLines',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Dark color for contrast
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'CONNECTING BOOKS,\nREADERS AND INSIGHTS',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54, // Dark color for readability
                  ),
                ),
                const SizedBox(height: 40),
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login'); // Navigate to Login Page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('LOGIN', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 10),
                // Signup Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup'); // Navigate to Signup Page
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text('SIGN UP', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
