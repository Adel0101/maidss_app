import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/login/auth_view_model.dart';
import 'package:task_manager_maidss/router/paths.dart';
import 'package:task_manager_maidss/services/network.dart';
import 'package:task_manager_maidss/utils/constants.dart';
import 'package:task_manager_maidss/utils/widgets/primary_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late StreamSubscription<bool> _networkSubscription;
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  void _login() async {
    _username = "emilys";
    _password = "emilyspass";
    // if (!_formKey.currentState!.validate()) return;

    // _formKey.currentState!.save();

    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
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
    _networkSubscription =
        NetworkService().networkStatusController.stream.listen((isOnline) {
      if (!isOnline) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection, try later')),
        );
      }
    });
  }

  @override
  void dispose() {
    _networkSubscription.cancel();
    super.dispose();
  }

  // Build method with form fields and login button
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: authViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Text(
                      'TODOWI',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: 'Username',
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constants.padding / 2),
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constants.padding / 2),
                              borderSide: const BorderSide(color: Colors.grey)),
                          fillColor: Colors.white,
                          filled: true),
                      onSaved: (value) => _username = value!.trim(),
                      validator: authViewModel.validateUsername,
                    ),
                    SizedBox(height: Constants.padding),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constants.padding / 2),
                              borderSide: const BorderSide(color: Colors.grey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(Constants.padding / 2),
                              borderSide: const BorderSide(color: Colors.grey)),
                          fillColor: Colors.white,
                          filled: true),
                      obscureText: true,
                      onSaved: (value) => _password = value!.trim(),
                      validator: authViewModel.validatePassword,
                    ),
                    SizedBox(height: Constants.padding),
                    PrimaryButton(
                      margin: EdgeInsets.zero,
                      onPress: _login,
                      title: const Text(
                        'Login',
                        style: Constants.primaryButtonTextStyle,
                      ),
                    ),
                    const Spacer(),
                    PrimaryButton(
                      margin: EdgeInsets.zero,
                      onPress: () {},
                      backgroundColor: Colors.white,
                      title: Text(
                        'Sign in with Google',
                        style: Constants.primaryButtonTextStyle
                            .copyWith(color: Colors.black),
                      ),
                    ),
                    SizedBox(height: Constants.padding / 2),
                    PrimaryButton(
                      margin: EdgeInsets.zero,
                      onPress: () {},
                      backgroundColor: Constants.facebookColor,
                      title: const Text(
                        'Sign in with Facebook',
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
