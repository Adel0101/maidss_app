import 'package:flutter/material.dart';
import 'package:task_manager_maidss/utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPress,
    this.margin,
    this.backgroundColor = Constants.primaryColor,
  });

  final Widget title;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Function() onPress;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 450),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPress,
        child: Container(
          margin: margin ?? EdgeInsets.all(Constants.padding / 2),
          alignment: Alignment.center,
          width: MediaQuery.sizeOf(context).width,
          height: 0.6 *
              (MediaQuery.sizeOf(context).height /
                  8), //TODO:: make it responsive
          decoration: BoxDecoration(
            color: backgroundColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: (0.1 * (MediaQuery.sizeOf(context).height / 8)),
                  spreadRadius: 2)
            ],
            borderRadius: BorderRadius.circular(0.1 *
                (MediaQuery.sizeOf(context).height /
                    8)), //TODO:: make it responsive
          ),
          child: title,
        ),
      ),
    );
  }
}
