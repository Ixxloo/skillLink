import 'package:flutterproject/data/users_data.dart';
import 'package:flutterproject/models/tasks.dart';

final List<TaskModel> initialTasks = [
  TaskModel(
    id: "t1",
    title: "Arabic-to-English Article Translation",
    description: "Looking for an accurate, natural-sounding English translation of an investigative feature article while preserving the journalistic tone.",
    category: "Translation",
    budget: 35,
    deadline: DateTime(2026, 12, 10),
    requester: users[0],
  ),
];
