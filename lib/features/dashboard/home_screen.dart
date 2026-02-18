import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/colors.dart';
import '../../app/theme/text_styles.dart';
import '../../core/debug_log.dart';
import '../../core/widgets/bouncy_button.dart';
import '../../core/widgets/cloud_card.dart';
import '../gamification/providers/gamification_service.dart';
import '../gamification/widgets/feedback_overlay.dart';
import '../gamification/widgets/star_display.dart';
import '../learning/models/module.dart';
import '../learning/ui/quiz_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    debugPrint('🏠 HomeScreen: initState called');
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    debugPrint('🏠 HomeScreen: dispose called');
    _confettiController.dispose();
    super.dispose();
  }

  void _openModule(LearningModule module) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(moduleId: module.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('🏠 HomeScreen: build called');
    // #region agent log
    debugLog('home_screen.dart:build', 'HomeScreen building', {}, hypothesisId: 'H5');
    // #endregion
    final progress = ref.watch(gamificationServiceProvider);
    debugPrint('🏠 HomeScreen: progress received (stars: ${progress.totalStars})');
    final unlockedModules = progress.unlockedModules;

    return FeedbackOverlay(
      confettiController: _confettiController,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text('RechenWelt', style: AppTextStyles.h2),
          centerTitle: true,
          actions: const [
            StarDisplay(),
            SizedBox(width: 16),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Willkommen, ${progress.name}! 👋',
                            style: AppTextStyles.h1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ).animate().fadeIn().moveX(begin: -20, end: 0),
                          const SizedBox(height: 4),
                          Text(
                            'Level ${progress.currentLevel} · ${progress.totalStars} ⭐',
                            style: AppTextStyles.bodyMedium,
                          ).animate().fadeIn(delay: 100.ms),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.switch_account_rounded, color: AppColors.primary),
                      onPressed: () => context.go('/profile-selection'),
                      tooltip: 'Profil Değiştir',
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                
                // New Action Buttons
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.shopping_basket_rounded,
                      label: 'Dükkan',
                      color: AppColors.accent,
                      onTap: () => context.push('/shop'),
                    ),
                    const SizedBox(width: 12),
                    _ActionButton(
                      icon: Icons.analytics_rounded,
                      label: 'Analiz',
                      color: AppColors.primary,
                      onTap: () => context.push('/stats'),
                    ),
                  ],
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 28),

                Text(
                  'Module',
                  style: AppTextStyles.h3,
                ).animate().fadeIn(delay: 150.ms),

                const SizedBox(height: 12),

                // Module cards
                ...allModules.asMap().entries.map((entry) {
                  final i = entry.key;
                  final module = entry.value;
                  final isUnlocked = unlockedModules.contains(module.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _ModuleCard(
                      module: module,
                      isUnlocked: isUnlocked,
                      onStart: isUnlocked ? () => _openModule(module) : null,
                    ).animate().fadeIn(delay: Duration(milliseconds: 200 + i * 100)).moveY(begin: 20, end: 0),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BouncyButton(
        onPressed: onTap,
        color: color,
        height: 54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.h3.copyWith(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final LearningModule module;
  final bool isUnlocked;
  final VoidCallback? onStart;

  const _ModuleCard({
    required this.module,
    required this.isUnlocked,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return CloudCard(
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.6,
        child: Row(
          children: [
            // Icon circle
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: module.color.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isUnlocked ? module.icon : Icons.lock_outline_rounded,
                    color: isUnlocked ? module.color : AppColors.textSecondary,
                    size: 28,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(module.title, style: AppTextStyles.h3),
                  const SizedBox(height: 2),
                  Text(
                    isUnlocked 
                      ? module.subtitle 
                      : 'Noch ${module.requiredStars} ⭐ benötigt',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Start button
            BouncyButton(
              width: 100,
              height: 44,
              color: isUnlocked ? module.color : AppColors.disabled,
              onPressed: onStart ?? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sammle ${module.requiredStars} ⭐ um dieses Modul zu öffnen!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(isUnlocked ? 'Starten' : 'Kilitli'),
            ),
          ],
        ),
      ),
    );
  }
}
