import 'package:flutter/material.dart';
import 'package:task_manager_maidss/features/dashboard/dashboard_view.dart';
import 'package:task_manager_maidss/features/login/login_view.dart';
import 'package:task_manager_maidss/router/paths.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // case Routes.initial:
    //   return MaterialPageRoute(
    //       settings: settings, builder: (_) => const SplashView());
    case Routes.login:
      return MaterialPageRoute(settings: settings, builder: (_) => LoginView());
    case Routes.dashboard:
      return MaterialPageRoute(
          settings: settings, builder: (_) => DashboardView());
    default:
      return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
                body: Center(
                    child: Text('No route defined for ${settings.name}')),
              ));
  }
}
