import 'package:flutter/material.dart';
import 'package:game/buttons/create_button.dart';

class HostScreen extends StatefulWidget {
  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  final TextEditingController _gameNameController = TextEditingController();
  final TextEditingController hostNameController = TextEditingController();
  int? _selectedPlayer;

  final List<int> playerOptions = [1, 2, 3, 4, 5, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade50,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade50,

        title: Text(
          'Create Game',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Game Name'),
              TextField(
                controller: _gameNameController,
                decoration: _inputDecoration(
                  hint: 'Enter game name',
                  icon: Icons.videogame_asset,
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel('Host Name'),
              TextField(
                controller: hostNameController,
                decoration: _inputDecoration(
                  hint: 'Enter your name',
                  icon: Icons.person,
                ),
              ),
              const SizedBox(height: 24),

              _buildLabel('Number of Players'),
              DropdownButtonFormField<int>(
                value: _selectedPlayer,
                items: playerOptions
                    .map(
                      (num) =>
                          DropdownMenuItem(value: num, child: Text('$num')),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedPlayer = val),
                decoration: _inputDecoration(
                  hint: 'Select number of players',
                  icon: Icons.people,
                ),
              ),
              const SizedBox(height: 48),

              Center(
                child: CreateButton(
                  gameName: _gameNameController.text,
                  playercount: _selectedPlayer ?? 2,
                  hostName: hostNameController.text.trim(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.blueGrey.shade800,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blue.shade900),
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blueGrey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade900, width: 1.5),
      ),
    );
  }
}
