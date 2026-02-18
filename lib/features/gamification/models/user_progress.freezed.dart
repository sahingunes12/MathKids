// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserProgress _$UserProgressFromJson(Map<String, dynamic> json) {
  return _UserProgress.fromJson(json);
}

/// @nodoc
mixin _$UserProgress {
  @HiveField(0)
  int get totalStars => throw _privateConstructorUsedError;
  @HiveField(1)
  int get currentLevel => throw _privateConstructorUsedError;
  @HiveField(2)
  int get diamonds => throw _privateConstructorUsedError;
  @HiveField(3)
  int get currentStreak => throw _privateConstructorUsedError;
  @HiveField(4)
  List<String> get unlockedModules => throw _privateConstructorUsedError;
  @HiveField(5)
  DateTime? get lastPlayedDate => throw _privateConstructorUsedError;
  @HiveField(6)
  int get totalCorrect => throw _privateConstructorUsedError;
  @HiveField(7)
  int get totalWrong => throw _privateConstructorUsedError;
  @HiveField(8)
  List<String> get ownedAccessories => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get id => throw _privateConstructorUsedError;
  @HiveField(10)
  String get name => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserProgressCopyWith<UserProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserProgressCopyWith<$Res> {
  factory $UserProgressCopyWith(
          UserProgress value, $Res Function(UserProgress) then) =
      _$UserProgressCopyWithImpl<$Res, UserProgress>;
  @useResult
  $Res call(
      {@HiveField(0) int totalStars,
      @HiveField(1) int currentLevel,
      @HiveField(2) int diamonds,
      @HiveField(3) int currentStreak,
      @HiveField(4) List<String> unlockedModules,
      @HiveField(5) DateTime? lastPlayedDate,
      @HiveField(6) int totalCorrect,
      @HiveField(7) int totalWrong,
      @HiveField(8) List<String> ownedAccessories,
      @HiveField(9) String? id,
      @HiveField(10) String name});
}

/// @nodoc
class _$UserProgressCopyWithImpl<$Res, $Val extends UserProgress>
    implements $UserProgressCopyWith<$Res> {
  _$UserProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalStars = null,
    Object? currentLevel = null,
    Object? diamonds = null,
    Object? currentStreak = null,
    Object? unlockedModules = null,
    Object? lastPlayedDate = freezed,
    Object? totalCorrect = null,
    Object? totalWrong = null,
    Object? ownedAccessories = null,
    Object? id = freezed,
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      totalStars: null == totalStars
          ? _value.totalStars
          : totalStars // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      diamonds: null == diamonds
          ? _value.diamonds
          : diamonds // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedModules: null == unlockedModules
          ? _value.unlockedModules
          : unlockedModules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastPlayedDate: freezed == lastPlayedDate
          ? _value.lastPlayedDate
          : lastPlayedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalCorrect: null == totalCorrect
          ? _value.totalCorrect
          : totalCorrect // ignore: cast_nullable_to_non_nullable
              as int,
      totalWrong: null == totalWrong
          ? _value.totalWrong
          : totalWrong // ignore: cast_nullable_to_non_nullable
              as int,
      ownedAccessories: null == ownedAccessories
          ? _value.ownedAccessories
          : ownedAccessories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserProgressImplCopyWith<$Res>
    implements $UserProgressCopyWith<$Res> {
  factory _$$UserProgressImplCopyWith(
          _$UserProgressImpl value, $Res Function(_$UserProgressImpl) then) =
      __$$UserProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int totalStars,
      @HiveField(1) int currentLevel,
      @HiveField(2) int diamonds,
      @HiveField(3) int currentStreak,
      @HiveField(4) List<String> unlockedModules,
      @HiveField(5) DateTime? lastPlayedDate,
      @HiveField(6) int totalCorrect,
      @HiveField(7) int totalWrong,
      @HiveField(8) List<String> ownedAccessories,
      @HiveField(9) String? id,
      @HiveField(10) String name});
}

/// @nodoc
class __$$UserProgressImplCopyWithImpl<$Res>
    extends _$UserProgressCopyWithImpl<$Res, _$UserProgressImpl>
    implements _$$UserProgressImplCopyWith<$Res> {
  __$$UserProgressImplCopyWithImpl(
      _$UserProgressImpl _value, $Res Function(_$UserProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalStars = null,
    Object? currentLevel = null,
    Object? diamonds = null,
    Object? currentStreak = null,
    Object? unlockedModules = null,
    Object? lastPlayedDate = freezed,
    Object? totalCorrect = null,
    Object? totalWrong = null,
    Object? ownedAccessories = null,
    Object? id = freezed,
    Object? name = null,
  }) {
    return _then(_$UserProgressImpl(
      totalStars: null == totalStars
          ? _value.totalStars
          : totalStars // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: null == currentLevel
          ? _value.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      diamonds: null == diamonds
          ? _value.diamonds
          : diamonds // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      unlockedModules: null == unlockedModules
          ? _value._unlockedModules
          : unlockedModules // ignore: cast_nullable_to_non_nullable
              as List<String>,
      lastPlayedDate: freezed == lastPlayedDate
          ? _value.lastPlayedDate
          : lastPlayedDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      totalCorrect: null == totalCorrect
          ? _value.totalCorrect
          : totalCorrect // ignore: cast_nullable_to_non_nullable
              as int,
      totalWrong: null == totalWrong
          ? _value.totalWrong
          : totalWrong // ignore: cast_nullable_to_non_nullable
              as int,
      ownedAccessories: null == ownedAccessories
          ? _value._ownedAccessories
          : ownedAccessories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserProgressImpl implements _UserProgress {
  const _$UserProgressImpl(
      {@HiveField(0) this.totalStars = 0,
      @HiveField(1) this.currentLevel = 1,
      @HiveField(2) this.diamonds = 0,
      @HiveField(3) this.currentStreak = 0,
      @HiveField(4)
      final List<String> unlockedModules = const ['addition_easy'],
      @HiveField(5) this.lastPlayedDate,
      @HiveField(6) this.totalCorrect = 0,
      @HiveField(7) this.totalWrong = 0,
      @HiveField(8) final List<String> ownedAccessories = const [],
      @HiveField(9) this.id,
      @HiveField(10) this.name = ''})
      : _unlockedModules = unlockedModules,
        _ownedAccessories = ownedAccessories;

  factory _$UserProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserProgressImplFromJson(json);

  @override
  @JsonKey()
  @HiveField(0)
  final int totalStars;
  @override
  @JsonKey()
  @HiveField(1)
  final int currentLevel;
  @override
  @JsonKey()
  @HiveField(2)
  final int diamonds;
  @override
  @JsonKey()
  @HiveField(3)
  final int currentStreak;
  final List<String> _unlockedModules;
  @override
  @JsonKey()
  @HiveField(4)
  List<String> get unlockedModules {
    if (_unlockedModules is EqualUnmodifiableListView) return _unlockedModules;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedModules);
  }

  @override
  @HiveField(5)
  final DateTime? lastPlayedDate;
  @override
  @JsonKey()
  @HiveField(6)
  final int totalCorrect;
  @override
  @JsonKey()
  @HiveField(7)
  final int totalWrong;
  final List<String> _ownedAccessories;
  @override
  @JsonKey()
  @HiveField(8)
  List<String> get ownedAccessories {
    if (_ownedAccessories is EqualUnmodifiableListView)
      return _ownedAccessories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ownedAccessories);
  }

  @override
  @HiveField(9)
  final String? id;
  @override
  @JsonKey()
  @HiveField(10)
  final String name;

  @override
  String toString() {
    return 'UserProgress(totalStars: $totalStars, currentLevel: $currentLevel, diamonds: $diamonds, currentStreak: $currentStreak, unlockedModules: $unlockedModules, lastPlayedDate: $lastPlayedDate, totalCorrect: $totalCorrect, totalWrong: $totalWrong, ownedAccessories: $ownedAccessories, id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserProgressImpl &&
            (identical(other.totalStars, totalStars) ||
                other.totalStars == totalStars) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.diamonds, diamonds) ||
                other.diamonds == diamonds) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            const DeepCollectionEquality()
                .equals(other._unlockedModules, _unlockedModules) &&
            (identical(other.lastPlayedDate, lastPlayedDate) ||
                other.lastPlayedDate == lastPlayedDate) &&
            (identical(other.totalCorrect, totalCorrect) ||
                other.totalCorrect == totalCorrect) &&
            (identical(other.totalWrong, totalWrong) ||
                other.totalWrong == totalWrong) &&
            const DeepCollectionEquality()
                .equals(other._ownedAccessories, _ownedAccessories) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalStars,
      currentLevel,
      diamonds,
      currentStreak,
      const DeepCollectionEquality().hash(_unlockedModules),
      lastPlayedDate,
      totalCorrect,
      totalWrong,
      const DeepCollectionEquality().hash(_ownedAccessories),
      id,
      name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      __$$UserProgressImplCopyWithImpl<_$UserProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserProgressImplToJson(
      this,
    );
  }
}

abstract class _UserProgress implements UserProgress {
  const factory _UserProgress(
      {@HiveField(0) final int totalStars,
      @HiveField(1) final int currentLevel,
      @HiveField(2) final int diamonds,
      @HiveField(3) final int currentStreak,
      @HiveField(4) final List<String> unlockedModules,
      @HiveField(5) final DateTime? lastPlayedDate,
      @HiveField(6) final int totalCorrect,
      @HiveField(7) final int totalWrong,
      @HiveField(8) final List<String> ownedAccessories,
      @HiveField(9) final String? id,
      @HiveField(10) final String name}) = _$UserProgressImpl;

  factory _UserProgress.fromJson(Map<String, dynamic> json) =
      _$UserProgressImpl.fromJson;

  @override
  @HiveField(0)
  int get totalStars;
  @override
  @HiveField(1)
  int get currentLevel;
  @override
  @HiveField(2)
  int get diamonds;
  @override
  @HiveField(3)
  int get currentStreak;
  @override
  @HiveField(4)
  List<String> get unlockedModules;
  @override
  @HiveField(5)
  DateTime? get lastPlayedDate;
  @override
  @HiveField(6)
  int get totalCorrect;
  @override
  @HiveField(7)
  int get totalWrong;
  @override
  @HiveField(8)
  List<String> get ownedAccessories;
  @override
  @HiveField(9)
  String? get id;
  @override
  @HiveField(10)
  String get name;
  @override
  @JsonKey(ignore: true)
  _$$UserProgressImplCopyWith<_$UserProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
