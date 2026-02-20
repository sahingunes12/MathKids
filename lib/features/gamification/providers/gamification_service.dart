import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/debug_log.dart';
import '../../learning/models/module.dart';
import '../models/user_progress.dart';
import 'profile_service.dart';

part 'gamification_service.g.dart';

@Riverpod(keepAlive: true)
class GamificationService extends _$GamificationService {
  static const String _progressBoxName = 'progress';

  @override
  UserProgress build() {
    debugPrint('🎮 GamificationService: build() called');
    final activeId = ref.watch(activeProfileIdProvider);
    // #region agent log
    debugLog('gamification_service.dart:build', 'build', {'activeId': activeId}, hypothesisId: 'H5');
    // #endregion
    
    if (activeId == null) {
      debugPrint('🎮 GamificationService: activeId is null, returning empty progress');
      // #region agent log
      debugLog('gamification_service.dart:build', 'returning empty UserProgress', {}, hypothesisId: 'H5');
      // #endregion
      return const UserProgress();
    }
    debugPrint('🎮 GamificationService: Loading progress for $activeId');
    return _loadProgress(activeId);
  }

  UserProgress _loadProgress(String id) {
    debugPrint('🎮 GamificationService: _loadProgress($id) starts');
    try {
      if (!Hive.isBoxOpen(_progressBoxName)) {
        debugPrint('⚠️ GamificationService: Progress box not open!');
        return UserProgress(id: id);
      }
      final box = Hive.box(_progressBoxName);
      final data = box.get(id);
      debugPrint('🎮 GamificationService: Hive.get($id) returned: ${data != null ? "Data found" : "Null"}');
      
      if (data == null) return UserProgress(id: id);
      
      if (data is! UserProgress) {
        debugPrint('⚠️ Warning: Found invalid data for profile $id in Hive. Resetting.');
        return UserProgress(id: id);
      }
      
      final progress = data;
      
      // Auto-sync unlocked modules with current stars on load
      final List<String> unlocked = List.from(progress.unlockedModules);
      bool changed = false;
      
      for (final module in allModules) {
        if (!unlocked.contains(module.id) && progress.totalStars >= module.requiredStars) {
          unlocked.add(module.id);
          changed = true;
        }
      }
      
      if (changed) {
        debugPrint('🎮 GamificationService: Auto-unlocked modules, returning updated progress');
        final updatedProgress = progress.copyWith(unlockedModules: unlocked);
        return updatedProgress;
      }
      
      debugPrint('🎮 GamificationService: Returning loaded progress');
      return progress;
    } catch (e, stack) {
      debugPrint('🔴 GamificationService: Error loading progress for profile $id: $e');
      debugPrint('🔴 Stack: $stack');
      return UserProgress(id: id);
    }
  }

  Future<void> _saveProgress(UserProgress progress) async {
    final activeId = ref.read(activeProfileIdProvider);
    if (activeId == null) return;

    final box = Hive.box(_progressBoxName);
    await box.put(activeId, progress);
    state = progress;
  }

  Future<void> addStars(int amount) async {
    final newTotalStars = state.totalStars + amount;
    
    // Check if new modules should be unlocked
    final List<String> unlocked = List.from(state.unlockedModules);
    
    for (final module in allModules) {
      if (!unlocked.contains(module.id) && newTotalStars >= module.requiredStars) {
        unlocked.add(module.id);
      }
    }

    // Auto level up every 50 stars
    final newLevel = (newTotalStars ~/ 50) + 1;

    final newProgress = state.copyWith(
      totalStars: newTotalStars,
      unlockedModules: unlocked,
      currentLevel: newLevel > state.currentLevel ? newLevel : state.currentLevel,
    );
    await _saveProgress(newProgress);
  }

  Future<void> updateStats({required bool isCorrect}) async {
    final newProgress = state.copyWith(
      totalCorrect: isCorrect ? state.totalCorrect + 1 : state.totalCorrect,
      totalWrong: isCorrect ? state.totalWrong : state.totalWrong + 1,
    );
    await _saveProgress(newProgress);
  }

  Future<bool> buyAccessory(String accessoryId, int price) async {
    if (state.totalStars < price) return false;
    if (state.ownedAccessories.contains(accessoryId)) return true;

    final List<String> owned = List.from(state.ownedAccessories)..add(accessoryId);
    final newProgress = state.copyWith(
      totalStars: state.totalStars - price,
      ownedAccessories: owned,
    );
    await _saveProgress(newProgress);
    return true;
  }

  Future<void> levelUp() async {
    final newProgress = state.copyWith(currentLevel: state.currentLevel + 1);
    await _saveProgress(newProgress);
  }
  
  Future<void> updateStreak() async {
    // Basic streak logic: check last played date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int newStreak = state.currentStreak;
    
    if (state.lastPlayedDate != null) {
      final lastPlayed = state.lastPlayedDate!;
      final lastDate = DateTime(lastPlayed.year, lastPlayed.month, lastPlayed.day);
      
      final difference = today.difference(lastDate).inDays;
      
      if (difference == 1) {
        newStreak++;
      } else if (difference > 1) {
        newStreak = 1; // Reset streak
      }
      // If difference == 0, already played today, do nothing
    } else {
      newStreak = 1; // First time playing
    }
    
    final newProgress = state.copyWith(
      currentStreak: newStreak,
      lastPlayedDate: now,
    );
    await _saveProgress(newProgress);
  }
  Future<void> toggleSound() async {
    final newProgress = state.copyWith(isSoundEnabled: !state.isSoundEnabled);
    await _saveProgress(newProgress);
  }

  Future<void> recordMistake(Map<String, dynamic> mistakeData) async {
    // Avoid duplicates based on question text or ID if available. 
    // tailored to store minimum data: operandA, operandB, type, answer
    final existing = state.mistakes.any((m) => 
      m['a'] == mistakeData['a'] && 
      m['b'] == mistakeData['b'] && 
      m['type'] == mistakeData['type']
    );

    if (!existing) {
      final newMistakes = List<Map<String, dynamic>>.from(state.mistakes)..add(mistakeData);
      final newProgress = state.copyWith(mistakes: newMistakes);
      await _saveProgress(newProgress);
    }
  }

  Future<void> clearMistake(Map<String, dynamic> mistakeData) async {
    final newMistakes = List<Map<String, dynamic>>.from(state.mistakes);
    newMistakes.removeWhere((m) => 
      m['a'] == mistakeData['a'] && 
      m['b'] == mistakeData['b'] && 
      m['type'] == mistakeData['type']
    );
    
    final newProgress = state.copyWith(mistakes: newMistakes);
    await _saveProgress(newProgress);
  }
}

