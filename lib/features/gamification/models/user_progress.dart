import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_progress.freezed.dart';
part 'user_progress.g.dart';

@freezed
@HiveType(typeId: 0)
class UserProgress with _$UserProgress {
  const factory UserProgress({
    @HiveField(0) @Default(0) int totalStars,
    @HiveField(1) @Default(1) int currentLevel,
    @HiveField(2) @Default(0) int diamonds,
    @HiveField(3) @Default(0) int currentStreak,
    @HiveField(4) @Default(['addition_easy']) List<String> unlockedModules,
    @HiveField(5) DateTime? lastPlayedDate,
    @HiveField(6) @Default(0) int totalCorrect,
    @HiveField(7) @Default(0) int totalWrong,
    @HiveField(8) @Default([]) List<String> ownedAccessories,
    @HiveField(9) String? id,
    @HiveField(10) @Default('') String name,
  }) = _UserProgress;

  factory UserProgress.fromJson(Map<String, dynamic> json) =>
      _$UserProgressFromJson(json);
}
