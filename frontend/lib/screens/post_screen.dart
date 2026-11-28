import 'package:flutter/material.dart';
import 'package:flutterproject/screens/auth_screen.dart';
import 'package:flutterproject/store/app_store.dart';

class PostScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onPosted;

  const PostScreen({
    super.key,
    required this.store,
    required this.onPosted,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descController = TextEditingController();
  final _budgetController = TextEditingController();

  String _postType = 'skill'; // 'skill' أو 'task'

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    _descController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _openAuth() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (authContext) => AuthScreen(
          store: widget.store,
          onSuccess: () {
            setState(() {});
            Navigator.pop(authContext);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.store.currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Create Post'),
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
                  leading: Icon(Icons.lock_outline, size: 36),
                  title: Text('Login required'),
                  subtitle: Text(
                    'Please login or sign up first to publish a skill or task.',
                  ),
                ),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: _openAuth,
                child: const Text('Login / Sign Up'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  const Text('Type: '),
                  Radio<String>(
                    value: 'skill',
                    groupValue: _postType,
                    onChanged: (val) => setState(() => _postType = val!),
                  ),
                  const Text('Skill'),
                  Radio<String>(
                    value: 'task',
                    groupValue: _postType,
                    onChanged: (val) => setState(() => _postType = val!),
                  ),
                  const Text('Task'),
                ],
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter title',
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                (val == null || val.trim().isEmpty) ? 'Enter title' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  hintText: 'Enter category',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Enter category'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter description',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Enter description'
                    : null,
              ),
              if (_postType == 'task') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _budgetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Budget (\$)',
                    hintText: 'Enter budget',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;

                  if (_postType == 'skill') {
                    widget.store.addSkill(
                      title: _titleController.text,
                      description: _descController.text,
                      category: _categoryController.text,
                    );
                  } else {
                    final budget = double.tryParse(_budgetController.text) ?? 20;
                    widget.store.addTask(
                      title: _titleController.text,
                      description: _descController.text,
                      category: _categoryController.text,
                      budget: budget,
                      deadline: DateTime.now().add(const Duration(days: 7)),
                    );
                  }

                  _titleController.clear();
                  _categoryController.clear();
                  _descController.clear();
                  _budgetController.clear();
                  widget.onPosted();
                },
                child: const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}