import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
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
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      color: AppColors.correct,
                      value: progress.totalCorrect.toDouble(),
                      title: '${progress.totalCorrect}',
                      radius: 80,
                      titleStyle: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                    PieChartSectionData(
                      color: AppColors.wrong,
                      value: progress.totalWrong.toDouble(),
                      title: '${progress.totalWrong}',
                      radius: 80,
                      titleStyle: AppTextStyles.h2.copyWith(color: Colors.white),
                    ),
                  ],
                  centerSpaceRadius: 0,
                  sectionsSpace: 2,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(width: 12, height: 12, color: AppColors.correct),
                    const SizedBox(width: 8),
                    Text('Doğru', style: AppTextStyles.bodyMedium)
                  ],
                ),
                const SizedBox(width: 24),
                Row(
                  children: [
                    Container(width: 12, height: 12, color: AppColors.wrong),
                    const SizedBox(width: 8),
                    Text('Yanlış', style: AppTextStyles.bodyMedium)
                  ],
                )
              ],
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
                          backgroundColor: AppColors.accent.withAlpha(50),
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
