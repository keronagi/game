import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playClick() async {
    await _player.play(AssetSource('sound/click.mp3'));
  }
}
