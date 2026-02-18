import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../core/widgets/cloud_card.dart';
import '../providers/profile_service.dart';

class ProfileSelectionScreen extends ConsumerWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeId = ref.watch(activeProfileIdProvider);
    final profileIds = ref.watch(profileServiceProvider);
    final profileNotifier = ref.read(profileServiceProvider.notifier);

    debugPrint('ProfileSelectionScreen: Building (activeId: $activeId, profileCount: ${profileIds.length})');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Seçimi'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: activeId != null 
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            )
          : null,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text('Wer lernt heute?', style: AppTextStyles.h1),
            const SizedBox(height: 8),
            Text('Wähle dein Profil aus', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 32),
            
            Expanded(
              child: profileIds.isEmpty
                  ? _buildEmptyState(context)
                  : _buildProfileGrid(context, ref, profileIds, profileNotifier),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: BouncyButton(
                onPressed: () => context.push('/add-profile'),
                color: AppColors.primary,
                child: const Text('Neues Profil ekle'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_add_rounded, size: 80, color: AppColors.textSecondary.withValues(alpha: 0.3)),
          const SizedBox(height: 24),
          Text(
            'Henüz profil yok.\nHadi bir tane oluşturalım!',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileGrid(BuildContext context, WidgetRef ref, List<String> ids, ProfileService notifier) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0, // Changed from 0.9 to 1.0 to give more height
      ),
      itemCount: ids.length,
      itemBuilder: (context, index) {
        final id = ids[index];
        final data = notifier.getProfileData(id);
        
        return CloudCard(
          child: InkWell(
            onTap: () async {
              await notifier.setActiveProfile(id);
              if (context.mounted) {
                context.go('/');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Use min to avoid stretching
                children: [
                  CircleAvatar(
                    radius: 30, // Slightly smaller avatar
                    backgroundColor: AppColors.accent.withValues(alpha: 0.2),
                    child: Text(
                      data?.name.isNotEmpty == true ? data!.name.substring(0, 1).toUpperCase() : '?',
                      style: AppTextStyles.h1.copyWith(color: AppColors.accent, fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      data?.name ?? 'Unbekannt',
                      style: AppTextStyles.h3.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${data?.totalStars ?? 0} ⭐',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
