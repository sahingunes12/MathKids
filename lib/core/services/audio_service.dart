import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_service.g.dart';

@Riverpod(keepAlive: true)
class AudioService extends _$AudioService {
  late AudioPlayer _player;

  @override
  void build() {
    _player = AudioPlayer();
    ref.onDispose(() => _player.dispose());
  }

  Future<void> playCorrect() async {
    await _player.play(AssetSource('audio/correct.mp3'));
  }

  Future<void> playWrong() async {
    await _player.play(AssetSource('audio/wrong.mp3'));
  }

  Future<void> playVictory() async {
    await _player.play(AssetSource('audio/success.mp3'));
  }
}
