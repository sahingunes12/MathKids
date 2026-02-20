import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class FeedbackOverlay extends StatefulWidget {
  final Widget child;
  final ConfettiController confettiController;
  final ValueNotifier<Color?>? flashNotifier;

  const FeedbackOverlay({
    super.key,
    required this.child,
    required this.confettiController,
    this.flashNotifier,
  });

  @override
  State<FeedbackOverlay> createState() => _FeedbackOverlayState();
}

class _FeedbackOverlayState extends State<FeedbackOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  Color _flashColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 0.4).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        }
      });

    widget.flashNotifier?.addListener(_handleFlash);
  }

  @override
  void didUpdateWidget(covariant FeedbackOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.flashNotifier != oldWidget.flashNotifier) {
      oldWidget.flashNotifier?.removeListener(_handleFlash);
      widget.flashNotifier?.addListener(_handleFlash);
    }
  }

  @override
  void dispose() {
    widget.flashNotifier?.removeListener(_handleFlash);
    _animationController.dispose();
    super.dispose();
  }

  void _handleFlash() {
    final color = widget.flashNotifier?.value;
    if (color != null && mounted) {
      setState(() {
        _flashColor = color;
      });
      _animationController.forward(from: 0);
      // Reset notifier after the flash starts
      Future.delayed(const Duration(milliseconds: 100), () {
         if (mounted) {
            widget.flashNotifier?.value = null;
         }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        // Flash overlay
        AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return IgnorePointer(
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Container(
                  color: _flashColor,
                ),
              ),
            );
          },
        ),
        // Confetti overlay
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