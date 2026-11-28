import 'package:flutter/material.dart';
import 'package:flutterproject/models/skills.dart';
import 'package:flutterproject/models/tasks.dart';
import 'package:flutterproject/store/app_store.dart';

class ExploreScreen extends StatefulWidget {
  final AppStore store;
  final VoidCallback onChanged;

  const ExploreScreen({
    super.key,
    required this.store,
    required this.onChanged,
  });

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSkills = widget.store.exploreType == ExploreType.skills;
    final List<SkillModel> skillsList = widget.store.filteredSkills;
    final List<TaskModel> tasksList = widget.store.filteredTasks;
    final categories = widget.store.categories;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      isSkills ? Colors.indigo : Colors.grey[300],
                      foregroundColor: isSkills ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      widget.store.setExploreType(ExploreType.skills);
                      widget.onChanged();
                    },
                    child: const Text('Skills'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      !isSkills ? Colors.indigo : Colors.grey[300],
                      foregroundColor: !isSkills ? Colors.white : Colors.black,
                    ),
                    onPressed: () {
                      widget.store.setExploreType(ExploreType.tasks);
                      widget.onChanged();
                    },
                    child: const Text('Tasks'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                widget.store.setSearchQuery(value);
                widget.onChanged();
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected =
                      widget.store.selectedCategory.toLowerCase() ==
                          cat.toLowerCase();

                  return InkWell(
                    onTap: () {
                      widget.store.setSelectedCategory(cat);
                      widget.onChanged();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            cat,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected ? Colors.indigo : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 2.5,
                            width: 36,
                            color: isSelected
                                ? Colors.indigo
                                : Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: isSkills
                  ? ListView.builder(
                itemCount: skillsList.length,
                itemBuilder: (context, index) {
                  final skill = skillsList[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.workspace_premium),
                      title: Text(skill.title),
                      subtitle: Text(
                        '${skill.category} • By ${skill.requester.name}\n${skill.description}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              )
                  : ListView.builder(
                itemCount: tasksList.length,
                itemBuilder: (context, index) {
                  final task = tasksList[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.assignment),
                      title: Text(task.title),
                      subtitle: Text(
                        '${task.category} • \$${task.budget} • By ${task.requester.name}\n${task.description}',
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}