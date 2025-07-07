import 'package:flutter/material.dart';
import 'package:game/widgets/playSound.dart';

class ControlButtons extends StatelessWidget {
  final VoidCallback onStop;
  final VoidCallback onComplete;
  final VoidCallback? onContinue;
  final bool isCompleteEnabled;
  final bool isPaused;

  const ControlButtons({
    super.key,
    required this.onStop,
    required this.onComplete,
    this.onContinue,
    required this.isCompleteEnabled,
    required this.isPaused,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildButton(
              context: context,
              label: "Stop",
              icon: Icons.stop_circle,
              color: Colors.red.shade600,
              onPressed: () {
                onStop();
                SoundManager.playClick();
              },
            ),
            _buildButton(
              context: context,
              label: "Complete",
              icon: Icons.check_circle,
              color: Colors.blue.shade800,
              onPressed: isCompleteEnabled
                  ? () {
                      onComplete(); //
                      SoundManager.playClick();
                    }
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 20),

        if (isPaused && onContinue != null)
          _buildButton(
            context: context,
            label: "Continue",
            icon: Icons.play_arrow,
            color: Colors.green.shade600,
            onPressed: () {
              onContinue!(); // ✅
              SoundManager.playClick();
            },
            fullWidth: true,
          ),
      ],
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth
          ? MediaQuery.of(context).size.width * 0.9
          : MediaQuery.of(context).size.width * 0.4,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 24, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
