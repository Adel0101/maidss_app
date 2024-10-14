import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/tasks/task_view_model.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({Key? key}) : super(key: key);

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  String _taskTitle = '';

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);

    return AlertDialog(
      title: Text('Add Task'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Task Title',
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a task title';
            }
            return null;
          },
          onSaved: (value) {
            _taskTitle = value!.trim();
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            // Close the dialog without doing anything
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              // Add the task
              taskViewModel.addTask(_taskTitle);
              // Close the dialog
              Navigator.of(context).pop();
            }
          },
          child: Text('Done'),
        ),
      ],
    );
  }
}
