import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_maidss/features/login/auth_view_model.dart';
import 'package:task_manager_maidss/router/paths.dart';
import 'package:task_manager_maidss/router/router.dart';
import 'package:task_manager_maidss/services/network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NetworkService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
      ],
      child: MaterialApp(
        title: 'Maidss Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: Routes.login,
        onGenerateRoute: generateRoute,
      ),
    );
  }
}
