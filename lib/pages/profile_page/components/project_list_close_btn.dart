import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_projects.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:provider/provider.dart';

class ProjectListCloseBtn extends StatelessWidget {
  const ProjectListCloseBtn({super.key, required this.onPressed});
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
      ProjectListState projectsListProvider =
        Provider.of<ProjectListState>(context);
    return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      projectsListProvider.collapse();
                      onPressed();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      // color: Colors.amber,
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/icons/x.svg',
                        fit: BoxFit.none,
                        colorFilter: ColorFilter.mode(
                            context.myTheme.greySecondary, BlendMode.srcIn),
                      ),
                    ),
                  );
  }
}