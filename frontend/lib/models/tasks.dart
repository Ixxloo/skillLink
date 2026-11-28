import 'package:flutterproject/models/users.dart';

class TaskModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final double budget;
  final DateTime deadline;
  final UserModel requester;
  final bool isMine;

  const TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.budget,
    required this.deadline,
    required this.requester,
    this.isMine = false,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? budget,
    DateTime? deadline,
    UserModel? requester,
    bool? isMine,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      budget: budget ?? this.budget,
      deadline: deadline ?? this.deadline,
      requester: requester ?? this.requester,
      isMine: isMine ?? this.isMine,
    );
  }
}