import 'package:flutter/material.dart';
import 'package:flutterproject/screens/welcome_screen.dart';
import 'package:flutterproject/store/app_store.dart';

void main() {
  runApp(const SkillLinkApp());
}

class SkillLinkApp extends StatefulWidget {
  const SkillLinkApp({super.key});

  @override
  State<SkillLinkApp> createState() => _SkillLinkAppState();
}

class _SkillLinkAppState extends State<SkillLinkApp> {
  late final AppStore _store;

  @override
  void initState() {
    super.initState();
    _store = AppStore();
  }

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SkillLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: WelcomeScreen(store: _store),
    );
  }
}