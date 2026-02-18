// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activeProfileIdHash() => r'8a12573dd7d6cad6947a3cf72a1c53ec4e27c9c8';

/// See also [activeProfileId].
@ProviderFor(activeProfileId)
final activeProfileIdProvider = Provider<String?>.internal(
  activeProfileId,
  name: r'activeProfileIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$activeProfileIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ActiveProfileIdRef = ProviderRef<String?>;
String _$profileServiceHash() => r'735263c286b7f419dddcfce0c38e5ac910ab89a9';

/// See also [ProfileService].
@ProviderFor(ProfileService)
final profileServiceProvider =
    NotifierProvider<ProfileService, List<String>>.internal(
  ProfileService.new,
  name: r'profileServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileService = Notifier<List<String>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
