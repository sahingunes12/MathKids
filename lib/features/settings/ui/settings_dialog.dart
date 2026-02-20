import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../gamification/providers/gamification_service.dart';

class SettingsDialog extends ConsumerWidget {
  const SettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(gamificationServiceProvider);
    final notifier = ref.read(gamificationServiceProvider.notifier);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ayarlar', style: AppTextStyles.h2),
            const SizedBox(height: 24),
            
            // Sound Toggle
            _SettingsTile(
              icon: progress.isSoundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              title: 'Ses Efektleri',
              trailing: Switch.adaptive(
                value: progress.isSoundEnabled,
                onChanged: (value) => notifier.toggleSound(),
                activeColor: AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Profil Değiştir
             _SettingsTile(
              icon: Icons.switch_account_rounded,
              title: 'Profil Değiştir',
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
              onTap: () {
                Navigator.of(context).pop();
                context.go('/profile-selection');
              },
            ),

            const SizedBox(height: 24),
            
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Kapat', style: AppTextStyles.h3.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: AppTextStyles.bodyMedium),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
