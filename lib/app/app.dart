import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/debug_log.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class RechenWeltApp extends ConsumerWidget {
  const RechenWeltApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // #region agent log
    debugLog('app.dart:build', 'RechenWeltApp building', {}, hypothesisId: 'H2');
    // #endregion
    debugPrint('RechenWeltApp: Building...');
    try {
      final router = ref.watch(routerProvider);
      debugPrint('RechenWeltApp: Router obtained');

      return MaterialApp.router(
        title: 'RechenWelt - Mathe 1. Klasse',
        theme: AppTheme.lightTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      );
    } catch (e, stack) {
      debugPrint('RechenWeltApp BUILD ERROR: $e');
      debugPrint('STACK TRACE: $stack');
      rethrow;
    }
  }
}
