import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/widgets/cloud_card.dart';
import '../../gamification/providers/gamification_service.dart';
import '../../gamification/providers/profile_service.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(gamificationServiceProvider);
    final profileIds = ref.watch(profileServiceProvider);
    final profileNotifier = ref.read(profileServiceProvider.notifier);

    final total = progress.totalCorrect + progress.totalWrong;
    final accuracy = total > 0 ? (progress.totalCorrect / total * 100).toStringAsFixed(1) : '0';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Veli Paneli', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Öğrenme Özeti', style: AppTextStyles.h1),
            if (progress.name.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(progress.name, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            ],
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    title: 'Doğru',
                    value: '${progress.totalCorrect}',
                    color: AppColors.correct,
                    icon: Icons.check_circle_rounded,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    title: 'Yanlış',
                    value: '${progress.totalWrong}',
                    color: AppColors.wrong,
                    icon: Icons.cancel_rounded,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            CloudCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Başarı Oranı', style: AppTextStyles.h3),
                      Text('%$accuracy', style: AppTextStyles.h1.copyWith(color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: total > 0 ? (progress.totalCorrect / total) : 0,
                    backgroundColor: AppColors.background,
                    color: AppColors.primary,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ),
            ),

            if (profileIds.isNotEmpty) ...[
              const SizedBox(height: 32),
              Text('Tüm Profiller', style: AppTextStyles.h1),
              const SizedBox(height: 12),
              ...profileIds.map((id) {
                final data = profileNotifier.getProfileData(id);
                if (data == null) return const SizedBox.shrink();
                final pTotal = data.totalCorrect + data.totalWrong;
                final pAccuracy = pTotal > 0 ? (data.totalCorrect / pTotal * 100).toStringAsFixed(0) : '0';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CloudCard(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                          child: Text(
                            data.name.isNotEmpty ? data.name.substring(0, 1).toUpperCase() : '?',
                            style: AppTextStyles.h3.copyWith(color: AppColors.accent),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.name.isNotEmpty ? data.name : 'Profil', style: AppTextStyles.h3),
                              Text('${data.totalCorrect} doğru · ${data.totalWrong} yanlış · %$pAccuracy', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Text('${data.totalStars} ⭐', style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                );
              }),
            ],
            
            const SizedBox(height: 48),
            
            Center(
              child: Text(
                'Harika gidiyorsun! 🎉\nÇocuğunuzun gelişimi güvende.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CloudCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.h1),
          Text(title, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}
