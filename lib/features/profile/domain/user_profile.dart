class UserProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String bio;
  final String avatarUrl;

  const UserProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.bio,
    required this.avatarUrl,
  });

  UserProfile copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? bio,
    String? avatarUrl,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
