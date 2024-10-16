import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/features/tasks/task_view_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';
import 'package:task_manager_maidss/utils/widgets/custom_todo_card.dart';

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
                    return CustomTodoCard(
                        task: task, taskViewModel: taskViewModel);
                  },
                ),
              ),
            ),
          ),
          if (dataState == DataState.More_Fetching)
            Padding(
              padding: EdgeInsets.only(bottom: Constants.padding),
              child: const Center(child: CircularProgressIndicator()),
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
