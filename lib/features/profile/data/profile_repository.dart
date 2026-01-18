import 'package:flutter/material.dart';
import 'package:suredone/features/profile/domain/user_profile.dart';

class ProfileRepository {
  // Singleton pattern
  static final ProfileRepository _instance = ProfileRepository._internal();
  factory ProfileRepository() => _instance;
  ProfileRepository._internal();

  // Initial mock data
  final ValueNotifier<UserProfile> profileNotifier = ValueNotifier(
    const UserProfile(
      name: 'Jerico de Jesus',
      email: 'jerico@example.com',
      phoneNumber: '+63 917 123 4567',
      bio: 'Regular user of SureDone. Loves clean spaces!',
      avatarUrl: 'https://via.placeholder.com/150',
    ),
  );

  UserProfile get currentProfile => profileNotifier.value;

  void updateProfile(UserProfile newProfile) {
    profileNotifier.value = newProfile;
  }
}
