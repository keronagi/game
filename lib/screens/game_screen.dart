import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final List<String> playersName;
  final String gameName;
  const GameScreen({
    super.key,
    required this.gameName,
    required this.playersName,
  });

  @override
  State<GameScreen> createState() => _gameScreenState();
}

class _gameScreenState extends State<GameScreen> {
  int currentRound = 1;
  final int totalRounds = 10;
  String currentLetter = "";
  Timer? _timer;
  int remainingTime = 60;
  List<String> usedLetters = [];
  late List<Map<String, dynamic>> playerscores;
  final TextEditingController boyController = TextEditingController();
  final TextEditingController girlController = TextEditingController();
  final TextEditingController objectController = TextEditingController();
  final TextEditingController amimalController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController plantController = TextEditingController();
  @override
  void initState() {
    playerscores = widget.playersName
        .map((name) => {"name": name, "score": 0})
        .toList();
    super.initState();
    _startNewRound();
    _startTimer();
  }

  void _startNewRound() {
    if (currentRound >= totalRounds) {
      genratetRandomLetter();
      _startTimer();
    }
  }

  void genratetRandomLetter() {
    const letters = "ابتثجحخدذرزسشصضقفكمنليغعهطظو";
    String randomLetter;
    do {
      randomLetter = letters[Random().nextInt(letters.length)];
    } while (usedLetters.contains(randomLetter));
    setState(() {
      currentLetter = randomLetter;
      usedLetters.add(randomLetter);
    });
  }

  void _showFinalResult() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "game over",
          style: TextStyle(fontSize: 30, color: Colors.blue.shade900),
        ),
        content: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(color: Colors.black12),
            children: [
              TableRow(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Player",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Score",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              ...playerscores.map((player) {
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${player['name']}"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("${player['score']}"),
                    ),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _restartGame();
            },
            child: Text("restart"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("ok"),
          ),
        ],
      ),
    );
  }

  void _startTimer() {
    _timer?.cancel();
    remainingTime = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          _endRound();
        }
      });
    });
  }

  void _endRound() {
    _timer?.cancel();
    for (var player in playerscores) {
      player['score'] += calculatePlayerScore(player);
    }
    if (currentRound < totalRounds) {
      setState(() {
        currentRound++;
      });
      _startNewRound();
    } else {
      _showFinalResult();
    }
  }

  int calculatePlayerScore(Map<String, dynamic> player) {
    return 10;
  }

  void _restartGame() {
    setState(() {
      currentRound = 1;
      usedLetters.clear();
      playerscores = playerscores
          .map((p) => {'name': p['name'], 'score': 0})
          .toList();
    });
    _startNewRound();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        title: Text(
          widget.gameName,
          style: TextStyle(
            fontSize: 40,
            color: Colors.pinkAccent.shade700,
            fontFamily: "cairo",
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(16),
        child: Column(
          children: [
            Center(
              child: Text(
                "round : $currentRound/$totalRounds",
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text("letter :$currentLetter", style: TextStyle(fontSize: 20)),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Text("time left : $remainingTime sec"),
          ],
        ),
      ),
    );
  }
}
