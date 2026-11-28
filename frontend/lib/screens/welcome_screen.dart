import 'package:flutter/material.dart';
import 'package:flutterproject/screens/auth_screen.dart';
import 'package:flutterproject/screens/main_shell.dart';
import 'package:flutterproject/store/app_store.dart';

class WelcomeScreen extends StatelessWidget {
  final AppStore store;

  const WelcomeScreen({super.key, required this.store});

  void _openAuth(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (authContext) => AuthScreen(
          store: store,
          onSuccess: () {
            Navigator.pushReplacement(
              authContext,
              MaterialPageRoute(
                builder: (_) => MainShell(store: store),
              ),
            );
          },
        ),
      ),
    );
  }

  void _enterApp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainShell(store: store),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SkillLink'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.handshake,
              size: 72,
              color: Colors.indigo,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to SkillLink',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Swap skills, post tasks, and collaborate easily.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => _openAuth(context),
              child: const Text('Login / Sign Up'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => _enterApp(context),
              child: const Text('Explore as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}