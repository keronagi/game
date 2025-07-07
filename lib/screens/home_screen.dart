import 'package:flutter/material.dart';
import 'package:game/buttons/host_button.dart';
import 'package:game/buttons/player_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  final String gameName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Game Icon
              Center(child: Image.asset('assets/images/brain.png', width: 100)),
              const SizedBox(height: 20),
              // Title
              Text(
                "Choose Your Role",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.blue.shade900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Are you hosting or joining?",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey.shade700,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 60),
              // Host Button
              HostButton(),
              const SizedBox(height: 20),
              // Player Button
              PlayerButton(gameName: gameName),
              const Spacer(),
              // Footer
              Text(
                "Made with : by Keroles",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
