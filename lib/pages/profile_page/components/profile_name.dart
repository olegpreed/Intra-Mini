import 'package:flutter/material.dart';

class ProfileName extends StatelessWidget {
  const ProfileName(
      {super.key, required this.firstName, required this.lastName});
  final String firstName;
  final String lastName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            firstName,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            lastName,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      ],
    );
  }
}
