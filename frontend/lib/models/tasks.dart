import 'package:flutterproject/models/users.dart';

class TaskModel{
  final int id;
  String taskName;
  String category;
  String description;
  DateTime deadline;
  double price;
  UserModel requester;
  bool isMine=false;

  TaskModel({
    required this.id,
    required this.taskName,
    required this.category,
    required this.description,
    required this.deadline,
    required this.price,
    required this.requester
});
}