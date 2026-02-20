import 'package:audioplayers/audioplayers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/gamification/providers/gamification_service.dart';

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
    final isSoundEnabled = ref.read(gamificationServiceProvider).isSoundEnabled;
    if (!isSoundEnabled) return;
    await _player.play(AssetSource('audio/correct.mp3'));
  }

  Future<void> playWrong() async {
    final isSoundEnabled = ref.read(gamificationServiceProvider).isSoundEnabled;
    if (!isSoundEnabled) return;
    await _player.play(AssetSource('audio/wrong.mp3'));
  }

  Future<void> playVictory() async {
    final isSoundEnabled = ref.read(gamificationServiceProvider).isSoundEnabled;
    if (!isSoundEnabled) return;
    await _player.play(AssetSource('audio/success.mp3'));
  }
}
