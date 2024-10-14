import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/login/auth_view_model.dart';
import 'package:task_manager_maidss/router/paths.dart';
import 'package:task_manager_maidss/services/network.dart';
import 'package:task_manager_maidss/utils/constants.dart';
import 'package:task_manager_maidss/utils/widgets/primary_button.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    print('err');
    print(_username);
    print(_password);

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    print(_username);
    try {
      bool success = await authViewModel.login(_username, _password);
      if (success) {
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    NetworkService().networkStatusController.stream.listen((isOnline) {
      if (!isOnline) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No internet connection, try later')),
        );
      }
    });
  }

  // Build method with form fields and login button
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: authViewModel.isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Username'),
                      onSaved: (value) => _username = value!.trim(),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter username' : null,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) => _password = value!.trim(),
                      validator: (value) =>
                          value!.isEmpty ? 'Please enter password' : null,
                    ),
                    SizedBox(height: 20),
                    PrimaryButton(
                      onPress: _login,
                      title: const Text(
                        'Login',
                        style: Constants.primaryButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
