// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProgressAdapter extends TypeAdapter<UserProgress> {
  @override
  final int typeId = 0;

  @override
  UserProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProgress(
      totalStars: fields[0] as int,
      currentLevel: fields[1] as int,
      diamonds: fields[2] as int,
      currentStreak: fields[3] as int,
      unlockedModules: (fields[4] as List).cast<String>(),
      lastPlayedDate: fields[5] as DateTime?,
      totalCorrect: fields[6] as int,
      totalWrong: fields[7] as int,
      ownedAccessories: (fields[8] as List).cast<String>(),
      id: fields[9] as String?,
      name: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProgress obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.totalStars)
      ..writeByte(1)
      ..write(obj.currentLevel)
      ..writeByte(2)
      ..write(obj.diamonds)
      ..writeByte(3)
      ..write(obj.currentStreak)
      ..writeByte(4)
      ..write(obj.unlockedModules)
      ..writeByte(5)
      ..write(obj.lastPlayedDate)
      ..writeByte(6)
      ..write(obj.totalCorrect)
      ..writeByte(7)
      ..write(obj.totalWrong)
      ..writeByte(8)
      ..write(obj.ownedAccessories)
      ..writeByte(9)
      ..write(obj.id)
      ..writeByte(10)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProgressImpl _$$UserProgressImplFromJson(Map<String, dynamic> json) =>
    _$UserProgressImpl(
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
      currentLevel: (json['currentLevel'] as num?)?.toInt() ?? 1,
      diamonds: (json['diamonds'] as num?)?.toInt() ?? 0,
      currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
      unlockedModules: (json['unlockedModules'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const ['addition_easy'],
      lastPlayedDate: json['lastPlayedDate'] == null
          ? null
          : DateTime.parse(json['lastPlayedDate'] as String),
      totalCorrect: (json['totalCorrect'] as num?)?.toInt() ?? 0,
      totalWrong: (json['totalWrong'] as num?)?.toInt() ?? 0,
      ownedAccessories: (json['ownedAccessories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
    );

Map<String, dynamic> _$$UserProgressImplToJson(_$UserProgressImpl instance) =>
    <String, dynamic>{
      'totalStars': instance.totalStars,
      'currentLevel': instance.currentLevel,
      'diamonds': instance.diamonds,
      'currentStreak': instance.currentStreak,
      'unlockedModules': instance.unlockedModules,
      'lastPlayedDate': instance.lastPlayedDate?.toIso8601String(),
      'totalCorrect': instance.totalCorrect,
      'totalWrong': instance.totalWrong,
      'ownedAccessories': instance.ownedAccessories,
      'id': instance.id,
      'name': instance.name,
    };
