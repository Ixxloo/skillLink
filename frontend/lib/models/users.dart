class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'Requester' أو 'Performer'
  final String bio;
  final String password;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.bio,
    required this.password
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? bio,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      bio: bio ?? this.bio,
      password: password ?? this.password,
    );
  }
}