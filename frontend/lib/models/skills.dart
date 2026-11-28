import 'package:flutterproject/models/users.dart';

class SkillModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String? imageUrl;
  final UserModel requester;
  final bool isMine;

  const SkillModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.imageUrl,
    required this.requester,
    this.isMine = false,
  });

  SkillModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? imageUrl,
    UserModel? requester,
    bool? isMine,
  }) {
    return SkillModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      requester: requester ?? this.requester,
      isMine: isMine ?? this.isMine,
    );
  }
}