import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/login/auth_view_model.dart';
import 'package:task_manager_maidss/router/paths.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await authViewModel.loadUserFromPreferences();

    if (authViewModel.isLoggedIn) {
      Navigator.pushReplacementNamed(context, Routes.dashboard);
    } else {
      Navigator.pushReplacementNamed(context, Routes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Display a loading indicator while checking login status
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
