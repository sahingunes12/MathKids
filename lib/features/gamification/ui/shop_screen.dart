import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../core/widgets/cloud_card.dart';
import '../models/accessory.dart';
import '../providers/gamification_service.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(gamificationServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Muz Dükkanı', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Header with star balance
          Container(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, color: Colors.orange, size: 40),
                const SizedBox(width: 12),
                Text(
                  '${progress.totalStars}',
                  style: AppTextStyles.h1.copyWith(fontSize: 48),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: allAccessories.length,
              itemBuilder: (context, index) {
                final item = allAccessories[index];
                final isOwned = progress.ownedAccessories.contains(item.id);

                return _ShopItemCard(
                  accessory: item,
                  isOwned: isOwned,
                  canAfford: progress.totalStars >= item.price,
                  onBuy: () => _handlePurchase(context, ref, item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePurchase(BuildContext context, WidgetRef ref, Accessory item) async {
    final success = await ref.read(gamificationServiceProvider.notifier).buyAccessory(item.id, item.price);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '${item.name} alındı! 🎉' : 'Yeterli yıldızın yok! ✨'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

class _ShopItemCard extends StatelessWidget {
  final Accessory accessory;
  final bool isOwned;
  final bool canAfford;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.accessory,
    required this.isOwned,
    required this.canAfford,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return CloudCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(accessory.icon, size: 36, color: AppColors.primary),
          const SizedBox(height: 8),
          Text(
            accessory.name,
            style: AppTextStyles.h3.copyWith(fontSize: 14),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          if (isOwned)
            Text('Sahipsin', style: AppTextStyles.bodyMedium.copyWith(color: Colors.green, fontSize: 12))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star_rounded, color: Colors.orange, size: 14),
                const SizedBox(width: 4),
                Text('${accessory.price}', style: AppTextStyles.h3.copyWith(fontSize: 14)),
              ],
            ),
          if (!isOwned) ...[
            const SizedBox(height: 8),
            BouncyButton(
              height: 32,
              color: canAfford ? AppColors.accent : AppColors.disabled,
              onPressed: canAfford ? onBuy : () {},
              child: const Text('Satın Al', style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}
