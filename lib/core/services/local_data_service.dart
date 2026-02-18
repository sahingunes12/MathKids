import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/gamification/models/user_progress.dart';

part 'local_data_service.g.dart';

class LocalDataService {
  static const String _settingsBoxName = 'settings';
  static const String _progressBoxName = 'progress';
  static const Duration _openTimeout = Duration(seconds: 5);

  Future<void> init() async {
    debugPrint('LocalDataService: Initializing Hive...');
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserProgressAdapter());
    }

    await _safeOpenBox(_settingsBoxName);
    await _safeOpenBox(_progressBoxName);
    debugPrint('LocalDataService: Hive initialized successfully');
  }

  Future<void> _safeOpenBox(String name) async {
    try {
      debugPrint('LocalDataService: Opening box "$name"...');
      await Hive.openBox(name).timeout(
        _openTimeout,
        onTimeout: () => throw TimeoutException('Hive open "$name" timed out'),
      );
    } on TimeoutException catch (e) {
      debugPrint('LocalDataService: $e. Clearing and reopening...');
      try {
        await Hive.deleteBoxFromDisk(name);
        await Hive.openBox(name);
        debugPrint('LocalDataService: Box "$name" cleared and reopened.');
      } catch (innerError) {
        debugPrint('LocalDataService: Fatal error opening box "$name": $innerError');
        rethrow;
      }
    } catch (e) {
      debugPrint('LocalDataService: Error opening box "$name": $e. Attempting to clear and reopen...');
      try {
        await Hive.deleteBoxFromDisk(name);
        await Hive.openBox(name);
        debugPrint('LocalDataService: Box "$name" cleared and reopened.');
      } catch (innerError) {
        debugPrint('LocalDataService: Fatal error opening box "$name": $innerError');
        rethrow;
      }
    }
  }

  // Generic methods to get/put data
  dynamic getSettings(String key, {dynamic defaultValue}) {
    final box = Hive.box(_settingsBoxName);
    return box.get(key, defaultValue: defaultValue);
  }

  Future<void> saveSettings(String key, dynamic value) async {
    final box = Hive.box(_settingsBoxName);
    await box.put(key, value);
  }
}

@Riverpod(keepAlive: true)
LocalDataService localDataService(Ref ref) {
  return LocalDataService();
}
