import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/tasks/components/alert_dialog.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/features/tasks/task_view_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({super.key});

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
                    return Dismissible(
                      key: Key(task.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        await showDialog(
                            context: context,
                            builder: (context) => TaskAlertDialog(
                                  value: task.todo,
                                  title: 'Delete Task',
                                  done: (title) {
                                    taskViewModel.deleteTask(task.id);
                                  },
                                ));
                      },
                      child: ListTile(
                        title: Text(task.todo),
                        trailing: Checkbox(
                          value: task.completed,
                          onChanged: (value) {
                            taskViewModel.updateTask(task.id, value!);
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return TaskAlertDialog(
                                title: 'Edit Task',
                                value: task.todo,
                                done: (title) {
                                  taskViewModel.updateTaskText(task.id, title);
                                },
                              );
                            },
                          );
                        },
                      ),
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
