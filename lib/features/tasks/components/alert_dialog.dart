import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/tasks/task_view_model.dart';

class TaskAlertDialog extends StatefulWidget {
  const TaskAlertDialog({super.key, this.value, this.title, this.done});
  final String? value;
  final String? title;
  final Function(String)? done;

  @override
  _TaskAlertDialogState createState() => _TaskAlertDialogState();
}

class _TaskAlertDialogState extends State<TaskAlertDialog> {
  final _formKey = GlobalKey<FormState>();
  String _taskTitle = '';

  @override
  void initState() {
    if (widget.value != null && widget.value!.isNotEmpty) {
      setState(() {
        _taskTitle = widget.value!;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    return AlertDialog(
      title: Text(widget.title ?? 'N/A'),
      content: Form(
        key: _formKey,
        child: widget.value != null || (widget.value?.isEmpty ?? false)
            ? TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Task Title',
                ),
                initialValue: _taskTitle,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
                onSaved: (value) {
                  _taskTitle = value!.trim();
                },
              )
            : const SizedBox.shrink(),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (widget.done != null) {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                widget.done!(_taskTitle);
                Navigator.of(context).pop();
              }
            } else {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                taskViewModel.addTask(_taskTitle);
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
