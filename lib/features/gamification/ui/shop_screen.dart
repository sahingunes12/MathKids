import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../app/theme/colors.dart';
import '../../../app/theme/text_styles.dart';
import '../models/accessory.dart';
import '../providers/gamification_service.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAccessories = ref.watch(gamificationServiceProvider.notifier).getAllAccessories();
    final purchasedAccessories = ref.watch(gamificationServiceProvider).purchasedAccessoryIds;

    final groupedAccessories = allAccessories.groupListsBy((acc) => acc.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Dükkan', style: AppTextStyles.h2),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24),
        itemCount: groupedAccessories.length,
        itemBuilder: (context, index) {
          final category = groupedAccessories.keys.elementAt(index);
          final accessories = groupedAccessories[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(category, style: AppTextStyles.h3),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: accessories.length,
                itemBuilder: (context, index) {
                  final accessory = accessories[index];
                  final isPurchased = purchasedAccessories.contains(accessory.id);

                  return GestureDetector(
                    onTap: () {
                      if (!isPurchased) {
                        ref.read(gamificationServiceProvider.notifier).purchaseAccessory(accessory);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isPurchased ? AppColors.primary.withAlpha(50) : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isPurchased ? AppColors.primary : AppColors.background,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(accessory.icon, style: const TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${accessory.cost}', style: AppTextStyles.h3),
                              const Text(' ⭐', style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
