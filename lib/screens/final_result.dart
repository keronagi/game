import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class FinalResult extends StatefulWidget {
  final List<String> players;
  final Map<String, Map<String, String>> answers;
  final void Function(Map<String, int>) onSubmit;
  final IO.Socket? socket;

  const FinalResult({
    super.key,
    required this.players,
    required this.answers,
    required this.onSubmit,
    this.socket,
  });

  @override
  State<FinalResult> createState() => _FinalResultState();
}

class _FinalResultState extends State<FinalResult> {
  final Map<String, int> scores = {};
  final Map<String, Set<String>> evaluatedAnswers = {};
  String? category;
  @override
  void initState() {
    super.initState();
    for (var player in widget.players) {
      scores[player] = 0;
      evaluatedAnswers[player] = {};
    }
  }

  void updateScore(String player, int value) {
    if (evaluatedAnswers[player]!.contains(category)) return;
    setState(() {
      scores[player] = (scores[player] ?? 0) + value;
      evaluatedAnswers[player]!.add(category!);
    });
  }

  void sendResults() {
    widget.socket?.emit("round result", scores);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSubmit(scores);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        title: Text(
          "Revision",
          style: TextStyle(
            fontSize: 26,
            color: Colors.blue.shade900,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.players.length,
        itemBuilder: (context, playerIndex) {
          final player = widget.players[playerIndex];
          final playerAnswers = widget.answers[player]!;

          return Card(
            elevation: 3,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "👤 ${player}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink.shade700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...playerAnswers.entries.map((entry) {
                    final category = entry.key;
                    final answer = entry.value;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ListTile(
                        title: Text(
                          "$category: $answer",
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: Wrap(
                          spacing: 8,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                              tooltip: "صحيح (10)",
                              onPressed: () => updateScore(player, 10),
                            ),
                            IconButton(
                              icon: Icon(Icons.handshake, color: Colors.orange),
                              tooltip: "تعادل (5)",
                              onPressed: () => updateScore(player, 5),
                            ),
                            IconButton(
                              icon: Icon(Icons.cancel, color: Colors.red),
                              tooltip: "خطأ (0)",
                              onPressed: () => updateScore(player, 0),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 10),
                  Divider(thickness: 1.2),
                  Text(
                    "Your score :${player}: ${scores[player]} pts",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: sendResults,
          icon: const Icon(Icons.send, size: 28, color: Colors.white),
          label: const Text(
            "Send result",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade800,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}
