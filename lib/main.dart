import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app/app.dart';
import 'core/debug_log.dart';
import 'core/services/local_data_service.dart';

void main() {
  runZonedGuarded(() async {
    // #region agent log
    debugLog('main.dart:main', 'main() started', {}, hypothesisId: 'H2');
    // #endregion
    debugPrint('🚀 MAIN STARTED');
    
    // Capture Flutter framework errors
    FlutterError.onError = (details) {
      final isOverflow = details.exception.toString().contains('overflowed') ||
          details.exception.toString().contains('RenderFlex');
      if (isOverflow) {
        debugPrint('FLUTTER LAYOUT (non-fatal): ${details.exception}');
        return;
      }
      FlutterError.presentError(details);
      debugPrint('🔴 FLUTTER FRAMEWORK ERROR: ${details.exception}');
      debugPrint('🔴 STACK TRACE: ${details.stack}');
    };

    try {
      WidgetsFlutterBinding.ensureInitialized();
      debugPrint('✅ WidgetsFlutterBinding initialized');

      // Show error widget instead of white screen when build throws
      ErrorWidget.builder = (FlutterErrorDetails details) {
        debugPrint('🔴 ErrorWidget built: ${details.exception}');
        return Material(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Bir hata oluştu.',
                    style: TextStyle(fontSize: 18, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${details.exception}',
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        );
      };

      // Lock orientation to portrait
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      
      // Precache fonts
      GoogleFonts.config.allowRuntimeFetching = true;

      // Initialize Hive
      debugPrint('📦 Initializing LocalDataService...');
      final localDataService = LocalDataService();
      await localDataService.init();
      debugPrint('✅ LocalDataService initialized');
      
      // #region agent log
      debugLog('main.dart:main', 'Hive init done, before runApp', {}, hypothesisId: 'H2');
      // #endregion
      
      debugPrint('🚀 Starting runApp...');
      runApp(
        ProviderScope(
          overrides: [
            localDataServiceProvider.overrideWithValue(localDataService),
          ],
          child: const RechenWeltApp(),
        ),
      );
      debugPrint('✅ runApp called');
      
    } catch (e, stack) {
      // #region agent log
      debugLog('main.dart:main', 'FATAL STARTUP ERROR', {'error': '$e', 'stack': '$stack'}, hypothesisId: 'H2');
      // #endregion
      debugPrint('🔴 FATAL STARTUP ERROR: $e');
      debugPrint('🔴 STACK TRACE: $stack');
    }
  }, (error, stack) {
    debugPrint('🔴 UNCAUGHT ASYNC ERROR: $error');
    debugPrint('🔴 STACK TRACE: $stack');
  });
}
