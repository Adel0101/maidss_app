import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';

import 'task_view_model.dart';

class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ChangeNotifierProvider(
      create: (context) => TaskViewModel(),
      child: Consumer<TaskViewModel>(
          builder: (BuildContext context, TaskViewModel controller, Widget? _) {
        switch (controller.dataState) {
          case DataState.Uninitialized:
            Future(() {
              controller.fetchData();
            });
            return _ListViewWidget(controller.dataList, false);
          case DataState.Initial_Fetching:
          case DataState.More_Fetching:
          case DataState.Refreshing:
            return _ListViewWidget(controller.dataList, true);
          case DataState.Fetched:
          case DataState.Error:
          case DataState.No_More_Data:
            return _ListViewWidget(controller.dataList, false);
        }
      }),
    ));
  }
}

class _ListViewWidget extends StatelessWidget {
  final List<Todo> _data;
  bool _isLoading;
  _ListViewWidget(this._data, this._isLoading);
  late DataState _dataState;
  late BuildContext _buildContext;
  @override
  Widget build(BuildContext context) {
    _dataState = Provider.of<TaskViewModel>(context, listen: false).dataState;
    _buildContext = context;
    return SafeArea(child: _scrollNotificationWidget());
  }

  Widget _scrollNotificationWidget() {
    return Column(
      children: [
        Expanded(
            child: NotificationListener<ScrollNotification>(
                onNotification: _scrollNotification,
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _onRefresh();
                  },
                  child: ListView.builder(
                    itemCount: _data.length,
                    itemBuilder: (context, index) {
                      Todo task = _data[index];
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
                ))),
        if (_dataState == DataState.More_Fetching)
          Padding(
            padding: EdgeInsets.only(bottom: Constants.padding),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  bool _scrollNotification(ScrollNotification scrollInfo) {
    if (!_isLoading &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _isLoading = true;
      Provider.of<TaskViewModel>(_buildContext, listen: false).fetchData();
    }
    return true;
  }

  _onRefresh() async {
    if (!_isLoading) {
      _isLoading = true;
      Provider.of<TaskViewModel>(_buildContext, listen: false)
          .fetchData(isRefresh: true);
    }
  }
}
