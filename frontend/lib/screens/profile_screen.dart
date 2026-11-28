import 'package:flutter/material.dart';
import 'package:flutterproject/models/skills.dart';
import 'package:flutterproject/models/tasks.dart';
import 'package:flutterproject/models/users.dart';
import 'package:flutterproject/screens/auth_screen.dart';
import 'package:flutterproject/screens/welcome_screen.dart';
import 'package:flutterproject/store/app_store.dart';

class ProfileScreen extends StatelessWidget {
  final AppStore store;
  final VoidCallback onChanged;

  const ProfileScreen({
    super.key,
    required this.store,
    required this.onChanged,
  });

  void _openAuth(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (authContext) => AuthScreen(
          store: store,
          onSuccess: () {
            onChanged();
            Navigator.pop(authContext);
          },
        ),
      ),
    );
  }

  void _editProfileDialog(BuildContext context, UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final bioController = TextEditingController(text: user.bio);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Enter bio',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                if (emailController.text.trim().isEmpty ||
                    !emailController.text.contains('@')) {
                  return;
                }
                store.updateCurrentUser(
                  name: nameController.text,
                  email: emailController.text,
                  role: user.role,
                  bio: bioController.text,
                  syncExploreMode: false,
                );
                onChanged();
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editSkillDialog(BuildContext context, SkillModel skill) {
    final titleController = TextEditingController(text: skill.title);
    final categoryController = TextEditingController(text: skill.category);
    final descController = TextEditingController(text: skill.description);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Skill'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Enter category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                store.updateMySkill(
                  id: skill.id,
                  title: titleController.text,
                  category: categoryController.text,
                  description: descController.text,
                  imageUrl: skill.imageUrl,
                );
                onChanged();
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _editTaskDialog(BuildContext context, TaskModel task) {
    final titleController = TextEditingController(text: task.title);
    final categoryController = TextEditingController(text: task.category);
    final descController = TextEditingController(text: task.description);
    final budgetController =
    TextEditingController(text: task.budget.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Task'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Enter category',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Budget (\$)',
                    hintText: 'Enter budget',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                final updatedBudget =
                    double.tryParse(budgetController.text) ?? task.budget;
                store.updateMyTask(
                  id: task.id,
                  title: titleController.text,
                  category: categoryController.text,
                  description: descController.text,
                  budget: updatedBudget,
                  deadline: task.deadline,
                );
                onChanged();
                Navigator.pop(dialogContext);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = store.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Card(
                child: ListTile(
                  leading: Icon(Icons.person_outline, size: 36),
                  title: Text('You are logged out'),
                  subtitle: Text(
                    'Login or create an account to manage your profile.',
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () => _openAuth(context),
                child: const Text('Login / Sign Up'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, size: 36),
                title: Text(user.name),
                subtitle: Text('${user.email}\nRole: ${user.role}\n${user.bio}'),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.indigo),
                  onPressed: () => _editProfileDialog(context, user),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final newRole = user.role.toLowerCase().contains('provider')
                    ? 'job requester'
                    : 'skill provider';
                store.updateCurrentUser(
                  name: user.name,
                  email: user.email,
                  role: newRole,
                  bio: user.bio,
                );
                onChanged();
              },
              child: const Text('Switch Role (Requester / Provider)'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () {
                store.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WelcomeScreen(store: store),
                  ),
                      (route) => false,
                );
              },
              child: const Text('Log Out'),
            ),
            const SizedBox(height: 16),
            const Text(
              'My Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...store.mySkills.map(
                  (s) => Card(
                child: ListTile(
                  title: Text(s.title),
                  subtitle: Text(s.category),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () => _editSkillDialog(context, s),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          store.removeMySkill(s.id);
                          onChanged();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'My Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...store.myTasks.map(
                  (t) => Card(
                child: ListTile(
                  title: Text(t.title),
                  subtitle: Text('${t.category} • \$${t.budget}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.indigo),
                        onPressed: () => _editTaskDialog(context, t),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          store.removeMyTask(t.id);
                          onChanged();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}