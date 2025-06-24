import 'dart:io';

import 'package:flutter/material.dart';
import 'package:game/buttons/start_game_button.dart';

class WaitingroomScreen extends StatefulWidget {
  final List<String> playersName;
  final String gameName;
  final int? playercount;
  final String gameCode;
  const WaitingroomScreen({
    super.key,
    required this.playersName,
    required this.gameName,
    required this.playercount,
    required this.gameCode,
  });

  @override
  State<WaitingroomScreen> createState() => _WaitingroomScreenState();
}

class _WaitingroomScreenState extends State<WaitingroomScreen> {
  List<String> connectedPlayers = ["you"];
  late ServerSocket _server;
  @override
  void initState() {
    _startserver;
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    final canStart = connectedPlayers.length == (widget.playercount ?? 1);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade100,
        centerTitle: true,
        title: Text(
          "waiting room",
          style: TextStyle(
            color: Colors.pinkAccent.shade700,
            fontSize: 30,
            fontFamily: "cairo",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade900, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "gameName :",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        TextSpan(
                          text: "   ${widget.gameName}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.pink.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "gameCode :",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        TextSpan(
                          text: "   ${widget.gameCode}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.pink.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "player :",
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        TextSpan(
                          text: "    ${widget.playercount}",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.pink.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Container(
              margin: EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.4,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 36),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade900, width: 2),
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "connected players",
                    style: TextStyle(
                      fontFamily: "cairo",
                      fontSize: 30,
                      color: Colors.blue.shade900,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Expanded(
                    child: ListView.builder(
                      itemCount: connectedPlayers.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.person, color: Colors.green),
                          title: Text(
                            "- ${connectedPlayers[index]}",
                            style: TextStyle(
                              fontFamily: "cairo",
                              fontSize: 22,
                              color: Colors.blueGrey.shade300,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            // if (canStart)
            StartGameButton(
              gameName: widget.gameName,
              playersName: widget.playersName,
            ),
          ],
        ),
      ),
    );
  }
}
