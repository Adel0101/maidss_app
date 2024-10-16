import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/tasks/components/alert_dialog.dart';
import 'package:task_manager_maidss/utils/constants.dart';

import 'components/list_view_widget.dart';
import 'task_view_model.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
      taskViewModel.fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'All Todos',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.primaryColor,
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return const TaskAlertDialog(
                title: 'Add Task',
                value: '',
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: const ListViewWidget(),
    );
  }
}
