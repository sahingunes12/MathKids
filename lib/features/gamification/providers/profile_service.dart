import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/debug_log.dart';
import '../models/user_progress.dart';

part 'profile_service.g.dart';

@Riverpod(keepAlive: true)
String? activeProfileId(ActiveProfileIdRef ref) {
  try {
    final boxOpen = Hive.isBoxOpen('settings');
    // #region agent log
    debugLog('profile_service.dart:activeProfileId', 'read', {'boxOpen': boxOpen}, hypothesisId: 'H4');
    // #endregion
    if (!boxOpen) return null;
    final box = Hive.box('settings');
    final value = box.get('active_profile_id') as String?;
    // #region agent log
    debugLog('profile_service.dart:activeProfileId', 'value', {'activeId': value}, hypothesisId: 'H4');
    // #endregion
    return value;
  } catch (e) {
    // #region agent log
    debugLog('profile_service.dart:activeProfileId', 'error', {'error': '$e'}, hypothesisId: 'H4');
    // #endregion
    debugPrint('Error reading activeProfileId from Hive: $e');
    return null;
  }
}

@Riverpod(keepAlive: true)
class ProfileService extends _$ProfileService {
  static const String _settingsBox = 'settings';
  static const String _progressBox = 'progress';
  static const String _activeProfileKey = 'active_profile_id';
  static const String _profileListKey = 'profile_ids';

  @override
  List<String> build() {
    try {
      if (!Hive.isBoxOpen(_settingsBox)) return [];
      final box = Hive.box(_settingsBox);
      final list = box.get(_profileListKey);
      
      if (list is List) {
        return list.cast<String>();
      }
      return [];
    } catch (e) {
      debugPrint('Error loading profiles from Hive: $e');
      return [];
    }
  }

  Future<void> setActiveProfile(String? id) async {
    // #region agent log
    debugLog('profile_service.dart:setActiveProfile', 'called', {'id': id}, hypothesisId: 'H1');
    // #endregion
    final box = Hive.box(_settingsBox);
    await box.put(_activeProfileKey, id);
    // Invalidate the activeProfileIdProvider to force rebuild of dependents
    ref.invalidate(activeProfileIdProvider);
    // #region agent log
    debugLog('profile_service.dart:setActiveProfile', 'done', {'id': id}, hypothesisId: 'H1');
    // #endregion
  }

  Future<String> createProfile(String name) async {
    // Check for duplicate name
    final existingProfiles = state.map((id) => getProfileData(id)).whereType<UserProgress>();
    if (existingProfiles.any((p) => p.name.toLowerCase() == name.toLowerCase())) {
      throw 'Bu isimde bir profil zaten var!';
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final newProfile = UserProgress(id: id, name: name);
    
    final box = Hive.box(_progressBox);
    await box.put(id, newProfile);

    final newList = [...state, id];
    final settingsBox = Hive.box(_settingsBox);
    await settingsBox.put(_profileListKey, newList);
    
    state = newList;
    return id;
  }

  Future<void> deleteProfile(String id) async {
    final box = Hive.box(_progressBox);
    await box.delete(id);

    final newList = state.where((profileId) => profileId != id).toList();
    final settingsBox = Hive.box(_settingsBox);
    await settingsBox.put(_profileListKey, newList);

    final activeId = Hive.box(_settingsBox).get(_activeProfileKey);
    if (activeId == id) {
      await setActiveProfile(null);
    }

    state = newList;
  }

  UserProgress? getProfileData(String id) {
    if (!Hive.isBoxOpen(_progressBox)) return null;
    final box = Hive.box(_progressBox);
    final data = box.get(id);
    return data is UserProgress ? data : null;
  }
}
