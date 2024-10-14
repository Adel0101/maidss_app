import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/tasks/components/alert_dialog.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';

import 'task_view_model.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  bool _isInit = true;

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show the add task dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddTaskDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
      body: _ListViewWidget(),
    );
  }
}

class _ListViewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final data = taskViewModel.dataList;
    final dataState = taskViewModel.dataState;

    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) =>
                  _scrollNotification(context, scrollInfo),
              child: RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    Todo task = data[index];
                    return ListTile(
                      title: Text(task.todo),
                      trailing: Checkbox(
                        value: task.completed,
                        onChanged: (value) {
                          // Implement toggle completed status
                        },
                      ),
                      onTap: () {
                        // Navigate to edit task view
                      },
                    );
                  },
                ),
              ),
            ),
          ),
          if (dataState == DataState.More_Fetching)
            Padding(
              padding: EdgeInsets.only(bottom: Constants.padding),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  bool _scrollNotification(
      BuildContext context, ScrollNotification scrollInfo) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    if (taskViewModel.dataState != DataState.More_Fetching &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      taskViewModel.fetchData();
    }
    return true;
  }

  Future<void> _onRefresh(BuildContext context) async {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    await taskViewModel.fetchData(isRefresh: true);
  }
}
