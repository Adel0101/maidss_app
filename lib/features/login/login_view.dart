import 'package:flutter/material.dart';
import 'package:task_manager_maidss/utils/constants.dart';
import 'package:task_manager_maidss/utils/widgets/primary_button.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            Text('TODOWI'),
            const Spacer(),
            PrimaryButton(
                title: const Text(
                  'Lets start',
                  style: Constants.primaryButtonTextStyle,
                ),
                onPress: () => print('start'))
          ],
        ),
      ),
    );
  }
}
