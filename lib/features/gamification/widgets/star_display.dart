import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../app/theme/text_styles.dart';
import '../providers/gamification_service.dart';

class StarDisplay extends ConsumerWidget {
  const StarDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(gamificationServiceProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.orange, size: 32)
              .animate(target: progress.totalStars > 0 ? 1 : 0) // Simple trigger
              .scale(duration: 300.ms, curve: Curves.elasticOut),
          const SizedBox(width: 8),
          Text(
            '${progress.totalStars}',
            style: AppTextStyles.h3.copyWith(color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
