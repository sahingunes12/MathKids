import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:audioplayers/audioplayers.dart';

class FeedbackOverlay extends StatefulWidget {
  final Widget child;
  final ConfettiController confettiController;

  const FeedbackOverlay({
    super.key,
    required this.child,
    required this.confettiController,
  });

  static void showSuccess(BuildContext context, {required ConfettiController controller}) {
    controller.play();
    // Ideally play sound here too via provider
  }

  static void showError(BuildContext context) {
    // Shake animation logic would be triggered via state or keys
    // For now we just implement the overlay part
  }

  @override
  State<FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: widget.confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
              Colors.yellow,
            ],
            numberOfParticles: 30,
            gravity: 0.3,
          ),
        ),
      ],
    );
  }
}
