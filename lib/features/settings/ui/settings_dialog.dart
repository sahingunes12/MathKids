import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../gamification/providers/gamification_service.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final soundEnabled = ref.watch(gamificationServiceProvider.select((p) => p.soundEnabled));

    return AlertDialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: Text('Ayarlar', style: AppTextStyles.h2.copyWith(color: AppColors.textPrimary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.volume_up_rounded, color: AppColors.textSecondary),
            title: Text('Ses Efektleri', style: AppTextStyles.bodyLg.copyWith(color: AppColors.textPrimary)),
            trailing: Switch(
              value: soundEnabled,
              onChanged: (value) {
                ref.read(gamificationServiceProvider.notifier).toggleSound(value);
              },
              activeTrackColor: AppColors.primary.withAlpha(100),
              activeColor: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                ref.read(gamificationServiceProvider.notifier).resetProgress();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tüm ilerleme sıfırlandı!')),
                );
              },
              child: const Text('İlerlemeyi Sıfırla'),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Kapat', style: AppTextStyles.bodyLg.copyWith(color: AppColors.primary)),
        ),
      ],
    );
  }
}
