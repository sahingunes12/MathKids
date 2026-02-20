import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart'; // Unused for now

class BouncyButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color? color;
  final double width;
  final double height;
  final double scaleRatio;

  const BouncyButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.width = 200,
    this.height = 60,
    this.scaleRatio = 0.95,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: widget.width,
        height: widget.height,
        transform: Matrix4.diagonal3Values(_isPressed ? widget.scaleRatio : 1.0, _isPressed ? widget.scaleRatio : 1.0, 1.0),
        transformAlignment: Alignment.center,
        decoration: BoxDecoration(
          color: widget.color ?? Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: DefaultTextStyle(
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Colors.white,
                ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
