import 'package:flutterproject/data/users_data.dart';
import 'package:flutterproject/models/skills.dart';

final List<SkillModel> initialSkills = [
  SkillModel(
    id: 's1',
    title: 'Arabic-English Translation',
    category: 'translation',
    description:
    'I can translate any article, document, or digital work from Arabic to English with clear, natural phrasing.',
    requester: users[1],
  ),
];