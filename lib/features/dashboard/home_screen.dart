import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/debug_log.dart';
import '../../core/widgets/bouncy_button.dart';
import '../gamification/providers/gamification_service.dart';
import '../gamification/widgets/feedback_overlay.dart';
import '../gamification/widgets/star_display.dart';
import '../gamification/models/user_progress.dart';
import '../learning/models/module.dart';
import '../learning/ui/quiz_screen.dart';
import '../learning/ui/time_attack_screen.dart';
import '../learning/ui/mistake_review_screen.dart';
import '../settings/ui/settings_dialog.dart';
import 'dashboard_theme.dart';

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
    debugLog('home_screen.dart:build', 'HomeScreen building', {}, hypothesisId: 'H5');
    final progress = ref.watch(gamificationServiceProvider);

    return FeedbackOverlay(
      confettiController: _confettiController,
      child: Scaffold(
        backgroundColor: DashboardTheme.surface,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                DashboardTheme.surfaceGradientStart,
                DashboardTheme.surfaceGradientEnd,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(context),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroCard(progress),
                        const SizedBox(height: 20),
                        _buildSectionLabel('Hızlı Erişim'),
                        const SizedBox(height: 12),
                        _buildQuickActions(context),
                        const SizedBox(height: 28),
                        _buildSectionLabel('Oyun Alanı'),
                        const SizedBox(height: 12),
                        _buildGameCards(context, progress),
                        const SizedBox(height: 28),
                        _buildSectionLabel('Modüller'),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.88,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final module = allModules[index];
                        final isUnlocked = progress.unlockedModules.contains(module.id);
                        return _DashboardModuleCard(
                          module: module,
                          isUnlocked: isUnlocked,
                          onTap: isUnlocked
                              ? () => _openModule(module)
                              : () {
                                  ScaffoldMessenger.of(context).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Bu modül için ${module.requiredStars} ⭐ gerekli!'),
                                      backgroundColor: DashboardTheme.accentMistakes,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(DashboardTheme.radiusSm),
                                      ),
                                    ),
                                  );
                                },
                        ).animate().scale(delay: Duration(milliseconds: 80 * index));
                      },
                      childCount: allModules.length,
                    ),
                  ),
                ),
                const SliverPadding(padding: EdgeInsets.only(bottom: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        'RechenWelt',
        style: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: DashboardTheme.primaryDark,
          letterSpacing: 0.5,
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BouncyButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const SettingsDialog(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DashboardTheme.cardBg,
              borderRadius: BorderRadius.circular(DashboardTheme.radiusMd),
              boxShadow: DashboardTheme.cardShadow,
            ),
            child: Icon(
              Icons.tune_rounded,
              color: DashboardTheme.textSecondary,
              size: 22,
            ),
          ),
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: StarDisplay(),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: DashboardTheme.textPrimary,
      ),
    ).animate().fadeIn();
  }

  Widget _buildHeroCard(UserProgress progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DashboardTheme.cardBg,
        borderRadius: BorderRadius.circular(DashboardTheme.radiusXl),
        border: Border.all(color: DashboardTheme.cardBorder, width: 1),
        boxShadow: DashboardTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [DashboardTheme.primaryLight, DashboardTheme.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const CircleAvatar(
              radius: 30,
              backgroundColor: DashboardTheme.surface,
              child: Text('🦄', style: TextStyle(fontSize: 32)),
            ),
          ).animate().shake(delay: 500.ms),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba,',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: DashboardTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  progress.name,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: DashboardTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _DashboardChip(
                      icon: Icons.workspace_premium_rounded,
                      label: 'Seviye ${progress.currentLevel}',
                      color: DashboardTheme.chipLevel,
                    ),
                    const SizedBox(width: 8),
                    _DashboardChip(
                      icon: Icons.local_fire_department_rounded,
                      label: '${progress.currentStreak} Gün',
                      color: DashboardTheme.chipStreak,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().slideX(begin: -0.05, end: 0);
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DashboardActionButton(
            icon: Icons.shopping_bag_rounded,
            label: 'Dükkan',
            color: DashboardTheme.accentShop,
            onTap: () => context.push('/shop'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DashboardActionButton(
            icon: Icons.insights_rounded,
            label: 'Analiz',
            color: DashboardTheme.accentStats,
            onTap: () => context.push('/stats'),
          ),
        ),
      ],
    ).animate().scale(delay: 150.ms);
  }

  Widget _buildGameCards(BuildContext context, UserProgress progress) {
    return Row(
      children: [
        Expanded(
          child: _DashboardGameCard(
            title: 'Zamana\nKarşı',
            icon: Icons.speed_rounded,
            color: DashboardTheme.accentTimeAttack,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const TimeAttackScreen()),
            ),
          ),
        ),
        if (progress.mistakes.isNotEmpty) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _DashboardGameCard(
              title: 'Hataları\nÇöz',
              icon: Icons.error_outline_rounded,
              color: DashboardTheme.accentMistakes,
              showBadge: true,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const MistakeReviewScreen()),
              ),
            ),
          ),
        ],
      ],
    ).animate().slideY(begin: 0.15, end: 0, delay: 250.ms);
  }
}

class _DashboardChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _DashboardChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(DashboardTheme.radiusSm),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _DashboardActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onPressed: onTap,
      scaleRatio: 0.97,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(DashboardTheme.radiusMd),
          boxShadow: DashboardTheme.buttonShadow(color),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: DashboardTheme.textOnPrimary, size: 24),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: DashboardTheme.textOnPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardGameCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final bool showBadge;
  final VoidCallback onTap;

  const _DashboardGameCard({
    required this.title,
    required this.icon,
    required this.color,
    this.showBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyButton(
      onPressed: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(DashboardTheme.radiusLg),
          boxShadow: DashboardTheme.buttonShadow(color),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -4,
              bottom: -4,
              child: Icon(icon, size: 64, color: Colors.white.withOpacity(0.2)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(DashboardTheme.radiusSm),
                      ),
                      child: Icon(icon, color: Colors.white, size: 24),
                    ),
                    if (showBadge)
                      Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                      ),
                  ],
                ),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardModuleCard extends StatelessWidget {
  final LearningModule module;
  final bool isUnlocked;
  final VoidCallback onTap;

  const _DashboardModuleCard({
    required this.module,
    required this.isUnlocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isUnlocked ? DashboardTheme.cardBg : DashboardTheme.surface;
    final borderColor = isUnlocked ? DashboardTheme.cardBorder : DashboardTheme.cardBorder.withOpacity(0.6);
    final iconColor = isUnlocked ? module.color : DashboardTheme.textSecondary;

    return BouncyButton(
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(DashboardTheme.radiusLg),
          border: Border.all(color: borderColor),
          boxShadow: DashboardTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(DashboardTheme.radiusMd),
                  ),
                ),
                Icon(
                  isUnlocked ? module.icon : Icons.lock_rounded,
                  size: 28,
                  color: iconColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              module.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isUnlocked ? DashboardTheme.textPrimary : DashboardTheme.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
