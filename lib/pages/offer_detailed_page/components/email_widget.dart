import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart'; // 👈 for Clipboard
import 'package:forty_two_planet/theme/app_theme.dart';

class EmailWidget extends StatelessWidget {
  const EmailWidget({super.key, required this.email});
  final String email;

  void _copyEmail(BuildContext context) {
    Clipboard.setData(ClipboardData(text: email));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        animation: AnimationController(vsync: Scaffold.of(context)),
        content: Text(
          'Email copied!',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        duration: const Duration(seconds: 1, milliseconds: 500),
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _copyEmail(context), // 👈 copy when tapped
        child: Row(
          children: [
            Expanded(
              child: Text(
                email,
                maxLines: 1,
                textAlign: TextAlign.end,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.myTheme.greyMain,
                    ),
              ),
            ),
            const SizedBox(width: 8),
            SvgPicture.asset(
              'assets/icons/copy.svg',
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                context.myTheme.greyMain,
                BlendMode.srcIn,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
