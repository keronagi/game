import 'package:flutter/material.dart';
import 'package:game/buttons/create_button.dart';

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> {
  final _gameNameController = TextEditingController();
  int? _selectedPlayer;
  final _playerOptions = [1, 2, 3, 4, 5, 6];

  @override
  void dispose() {
    _gameNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        centerTitle: true,
        title: Text(
          'Host Game',
          style: TextStyle(
            fontFamily: 'cairo',
            fontSize: 35,
            color: Colors.pinkAccent.shade700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Text(
                '* Input your name of game',
                style: TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 30,
                  color: Colors.blue.shade900,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              TextField(
                controller: _gameNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.games, size: 30),
                  hintText: 'Input game name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Divider(thickness: 2, color: Colors.grey.shade400),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              Text(
                '* Choose number of players',
                style: TextStyle(
                  fontFamily: 'cairo',
                  fontSize: 28,
                  color: Colors.blue.shade900,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              DropdownButtonFormField<int>(
                value: _selectedPlayer,
                items: _playerOptions
                    .map(
                      (n) =>
                          DropdownMenuItem(value: n, child: Text('$n Player')),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _selectedPlayer = v),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  hintText: 'Players',
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.15),
              CreateButton(
                gameName: _gameNameController.text,
                playercount: _selectedPlayer ?? 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
