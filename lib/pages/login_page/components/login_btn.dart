import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class LoginBtn extends StatelessWidget {
  const LoginBtn({super.key, required this.onPressed});
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: Layout.bigBtnHeight,
        padding: EdgeInsets.symmetric(horizontal: Layout.padding * 1.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Layout.bigBtnHeight),
          color: context.myTheme.greySecondary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Log in with 42',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SvgPicture.asset('assets/icons/login.svg',
                width: Layout.screenWidth * 0.06,
                colorFilter: ColorFilter.mode(
                    Theme.of(context).primaryColor, BlendMode.srcIn)),
          ],
        ),
      ),
    );
  }
}
