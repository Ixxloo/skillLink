class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'Requester' أو 'Performer'
  final String bio;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? headline,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      bio: headline ?? this.bio,
    );
  }
}