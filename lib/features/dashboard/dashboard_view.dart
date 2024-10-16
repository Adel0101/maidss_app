import 'package:flutter/material.dart';
import 'package:task_manager_maidss/features/tasks/task_view.dart';

// this is a base file to hold multiple pages to enhance and facilitate user navigation
class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return const TaskListView();
  }
}
