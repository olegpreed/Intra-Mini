import 'package:flutter/material.dart';

class FrozenTag extends StatelessWidget {
  const FrozenTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 5, top: 2, bottom: 2),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text('frozen ❄️',
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.blue)),
    );
  }
}
