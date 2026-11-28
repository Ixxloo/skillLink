import 'package:flutter/material.dart';
import 'package:flutterproject/store/app_store.dart';

class AuthScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onSuccess;

  const AuthScreen({
    super.key,
    required this.store,
    required this.onSuccess,
  });

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLogin = true;
  String _role = 'job requester';
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    if (_isLogin) {
      final isValid = widget.store.login(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!isValid) {
        setState(() {
          _errorMessage = 'Invalid email or password';
        });
        return;
      }

      widget.onSuccess();
    } else {
      widget.store.signUp(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        role: _role,
        bio: _bioController.text,
      );

      widget.onSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
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
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isLogin ? Colors.indigo : Colors.grey[300],
                        foregroundColor:
                        _isLogin ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() {
                        _isLogin = true;
                        _errorMessage = null;
                      }),
                      child: const Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        !_isLogin ? Colors.indigo : Colors.grey[300],
                        foregroundColor:
                        !_isLogin ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() {
                        _isLogin = false;
                        _errorMessage = null;
                      }),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (!_isLogin) ...[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) =>
                  (val == null || val.trim().isEmpty) ? 'Enter name' : null,
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty || !val.contains('@')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              if (!_isLogin) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Role: '),
                    Radio<String>(
                      value: 'job requester',
                      groupValue: _role,
                      onChanged: (val) => setState(() => _role = val!),
                    ),
                    const Text('Requester'),
                    Radio<String>(
                      value: 'skill provider',
                      groupValue: _role,
                      onChanged: (val) => setState(() => _role = val!),
                    ),
                    const Text('Provider'),
                  ],
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    hintText: 'Short description about you',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _submit,
                child: Text(_isLogin ? 'Login' : 'Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}