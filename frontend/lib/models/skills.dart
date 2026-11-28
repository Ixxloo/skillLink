import 'package:flutterproject/models/users.dart';

class SkillModel {
  final int id;
  String skillName;
  String category;
  String description;
  double price;
  UserModel provider;
  bool isMine=false;

  SkillModel({
    required this.id,
    required this.skillName,
    required this.category,
    required this.description,
    required this.price,
    required this.provider,
  });
}
