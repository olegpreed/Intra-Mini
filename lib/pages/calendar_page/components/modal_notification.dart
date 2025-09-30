import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class ModalNotification extends StatelessWidget {
  const ModalNotification(
      {super.key, required this.event, required this.dialogContext});
  final dynamic event;
  final BuildContext dialogContext;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.myTheme.greyMain,
      title: Center(child: const Text('Notify me')),
      content: const Text('Notification feature is not available yet.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
