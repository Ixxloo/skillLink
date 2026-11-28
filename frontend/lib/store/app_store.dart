import 'package:flutter/foundation.dart';
import 'package:flutterproject/data/skills_data.dart';
import 'package:flutterproject/data/tasks_data.dart';
import 'package:flutterproject/data/users_data.dart';
import 'package:flutterproject/models/skills.dart';
import 'package:flutterproject/models/tasks.dart';
import 'package:flutterproject/models/users.dart';

enum ExploreType { skills, tasks }

class AppStore extends ChangeNotifier {
  UserModel? _currentUser;
  final List<TaskModel> _tasks = List<TaskModel>.from(initialTasks);
  final List<SkillModel> _skills = List<SkillModel>.from(initialSkills);

  String _searchQuery = '';
  String _selectedCategory = 'All';
  ExploreType _exploreType = ExploreType.skills;

  AppStore() {
    _applyDefaultExploreTypeForRole(_currentUser?.role ?? 'job requester');
  }

  // --- Core Getters ---
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  List<TaskModel> get tasks => List.unmodifiable(_tasks);
  List<SkillModel> get skills => List.unmodifiable(_skills);
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;
  ExploreType get exploreType => _exploreType;

  String _formatCategory(String raw) {
    final trimmed = raw.trim().toLowerCase();
    if (trimmed.isEmpty) return '';
    return trimmed[0].toUpperCase() + trimmed.substring(1);
  }

  List<String> get categories {
    final set = <String>{'All'};
    for (final task in _tasks) {
      final formatted = _formatCategory(task.category);
      if (formatted.isNotEmpty) set.add(formatted);
    }
    for (final skill in _skills) {
      final formatted = _formatCategory(skill.category);
      if (formatted.isNotEmpty) set.add(formatted);
    }
    return set.toList();
  }

  // --- Explore Mode (Skills vs. Tasks) ---
  void _applyDefaultExploreTypeForRole(String role) {
    final normalized = role.trim().toLowerCase();
    if (normalized.contains('provider') || normalized.contains('performer')) {
      _exploreType = ExploreType.tasks;
    } else {
      _exploreType = ExploreType.skills;
    }
  }

  void setExploreType(ExploreType type) {
    if (_exploreType == type) return;
    _exploreType = type;
    notifyListeners();
  }

  void syncExploreTypeWithCurrentUser() {
    _applyDefaultExploreTypeForRole(_currentUser?.role ?? 'job requester');
    notifyListeners();
  }

  // --- Ownership Helpers ---
  bool isTaskMine(TaskModel task) {
    final user = _currentUser;
    if (user == null) return false;
    return task.isMine || task.requester.id == user.id;
  }

  bool isSkillMine(SkillModel skill) {
    final user = _currentUser;
    if (user == null) return false;
    return skill.isMine || skill.requester.id == user.id;
  }

  List<TaskModel> get myTasks => _tasks.where(isTaskMine).toList();
  List<SkillModel> get mySkills => _skills.where(isSkillMine).toList();

  // --- Search & Category Filtering ---
  bool _matchesFilter(String title, String description, String category) {
    final categoryMatches = _selectedCategory == 'All' ||
        category.trim().toLowerCase() == _selectedCategory.trim().toLowerCase();

    final query = _searchQuery.trim().toLowerCase();
    final searchMatches = query.isEmpty ||
        title.toLowerCase().contains(query) ||
        description.toLowerCase().contains(query) ||
        category.toLowerCase().contains(query);

    return categoryMatches && searchMatches;
  }

  List<TaskModel> get filteredTasks => _tasks
      .where((task) => _matchesFilter(task.title, task.description, task.category))
      .toList();

  List<SkillModel> get filteredSkills => _skills
      .where(
        (skill) => _matchesFilter(skill.title, skill.description, skill.category),
  )
      .toList();

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedCategory = 'All';
    notifyListeners();
  }

  // --- Tasks CRUD ---
  void addTask({
    required String title,
    required String description,
    required String category,
    required double budget,
    required DateTime deadline,
  }) {
    final user = _currentUser;
    if (user == null) return;

    final newTask = TaskModel(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      description: description.trim(),
      category: category.trim(),
      budget: budget,
      deadline: deadline,
      requester: user,
      isMine: true,
    );
    _tasks.insert(0, newTask);
    notifyListeners();
  }

  void updateMyTask({
    required String id,
    required String title,
    required String description,
    required String category,
    required double budget,
    required DateTime deadline,
  }) {
    final user = _currentUser;
    if (user == null) return;

    final index = _tasks.indexWhere((task) => task.id == id && isTaskMine(task));
    if (index == -1) return;

    _tasks[index] = _tasks[index].copyWith(
      title: title.trim(),
      description: description.trim(),
      category: category.trim(),
      budget: budget,
      deadline: deadline,
      requester: user,
      isMine: true,
    );
    notifyListeners();
  }

  void removeMyTask(String id) {
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == id && isTaskMine(task));
    if (_tasks.length != initialLength) {
      notifyListeners();
    }
  }

  // --- Skills CRUD ---
  void addSkill({
    required String title,
    required String description,
    required String category,
    String? imageUrl,
  }) {
    final user = _currentUser;
    if (user == null) return;

    final cleanedUrl = imageUrl?.trim();
    final newSkill = SkillModel(
      id: 's_${DateTime.now().millisecondsSinceEpoch}',
      title: title.trim(),
      description: description.trim(),
      category: category.trim(),
      imageUrl: (cleanedUrl == null || cleanedUrl.isEmpty) ? null : cleanedUrl,
      requester: user,
      isMine: true,
    );
    _skills.insert(0, newSkill);
    notifyListeners();
  }

  void updateMySkill({
    required String id,
    required String title,
    required String description,
    required String category,
    String? imageUrl,
  }) {
    final user = _currentUser;
    if (user == null) return;

    final index = _skills.indexWhere(
          (skill) => skill.id == id && isSkillMine(skill),
    );
    if (index == -1) return;

    final cleanedUrl = imageUrl?.trim();
    _skills[index] = _skills[index].copyWith(
      title: title.trim(),
      description: description.trim(),
      category: category.trim(),
      imageUrl: (cleanedUrl == null || cleanedUrl.isEmpty) ? null : cleanedUrl,
      requester: user,
      isMine: true,
    );
    notifyListeners();
  }

  void removeMySkill(String id) {
    final initialLength = _skills.length;
    _skills.removeWhere((skill) => skill.id == id && isSkillMine(skill));
    if (_skills.length != initialLength) {
      notifyListeners();
    }
  }

  // --- Auth & User Management ---
  bool login({required String email, required String password}) {
    final cleanEmail = email.trim().toLowerCase();

    for (final u in users) {
      if (u.email.trim().toLowerCase() == cleanEmail &&
          u.password == password) {
        _currentUser = u;
        _applyDefaultExploreTypeForRole(u.role);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void signUp({
    required String name,
    required String email,
    required String password,
    required String role,
    required String bio,
  }) {
    final newUser = UserModel(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      email: email.trim(),
      password: password,
      role: role.trim(),
      bio: bio.trim().isEmpty ? 'SkillLink member' : bio.trim(),
    );
    users.add(newUser);
    _currentUser = newUser;
    _applyDefaultExploreTypeForRole(newUser.role);
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateCurrentUser({
    required String name,
    required String email,
    required String role,
    required String bio,
    bool syncExploreMode = true,
  }) {
    final user = _currentUser;
    if (user == null) return;

    _currentUser = user.copyWith(
      name: name.trim(),
      email: email.trim(),
      role: role.trim(),
      bio: bio.trim(),
    );
    if (syncExploreMode) {
      _applyDefaultExploreTypeForRole(_currentUser!.role);
    }
    notifyListeners();
  }

  void switchCurrentUser(UserModel user, {bool syncExploreMode = true}) {
    _currentUser = user;
    if (syncExploreMode) {
      _applyDefaultExploreTypeForRole(user.role);
    }
    notifyListeners();
  }
}