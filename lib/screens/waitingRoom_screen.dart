import 'dart:io';
import 'package:flutter/material.dart';
import 'package:game/buttons/start_game_button.dart';

class WaitingroomScreen extends StatefulWidget {
  final List<String> playersName;
  final String gameName;
  final int? playercount;
  final String? hostName;
  final String gameCode;
  const WaitingroomScreen({
    super.key,
    required this.hostName,
    required this.playersName,
    required this.gameName,
    required this.playercount,
    required this.gameCode,
  });

  @override
  State<WaitingroomScreen> createState() => _WaitingroomScreenState();
}

class _WaitingroomScreenState extends State<WaitingroomScreen> {
  List<String> connectedPlayers = [];
  late ServerSocket _server;

  @override
  void initState() {
    super.initState();
    if (widget.hostName != null) {
      connectedPlayers.add(widget.hostName!);
    }
    _startserver();
  }

  Future<void> _startserver() async {
    _server = await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
    _server.listen((client) {
      client.listen((data) {
        final playerName = String.fromCharCodes(data).trim();
        setState(() {
          connectedPlayers.add(playerName);
        });
        client.write("welcome $playerName");
      });
    });
  }

  @override
  void dispose() {
    _server.close();
    super.dispose();
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 20, color: Colors.pink.shade500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canStart = connectedPlayers.length == (widget.playercount ?? 1);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text(
          "Waiting Room",
          style: TextStyle(
            color: Colors.blue.shade900,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("Game Name:", widget.gameName),
                    _infoRow("Game Code:", widget.gameCode),
                    _infoRow("Players:", "${widget.playercount}"),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Connected Players",
                      style: TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: connectedPlayers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: Icon(Icons.person, color: Colors.green),
                            title: Text(
                              connectedPlayers[index],
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueGrey.shade700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            if (canStart)
              StartGameButton(
                gameName: widget.gameName,
                playersName: connectedPlayers,
                myName: widget.hostName!,
              ),
          ],
        ),
      ),
    );
  }
}
