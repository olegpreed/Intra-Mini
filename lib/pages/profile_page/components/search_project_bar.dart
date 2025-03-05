import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:provider/provider.dart';

class SearchProjectBar extends StatefulWidget {
  const SearchProjectBar({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<SearchProjectBar> createState() => _SearchProjectBarState();
}

class _SearchProjectBarState extends State<SearchProjectBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/searchbar.svg',
            colorFilter: ColorFilter.mode(
                context.myTheme.greySecondary, BlendMode.srcIn),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: widget.controller,
              keyboardType: TextInputType.text,
              keyboardAppearance:
                  Provider.of<SettingsProvider>(context).isDarkMode
                      ? Brightness.dark
                      : Brightness.light,
              cursorColor: context.myTheme.intra,
              showCursor: true,
              autofocus: true,
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              cursorHeight: Theme.of(context).textTheme.bodyMedium?.fontSize,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.all(0),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                hintText: 'Search project',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.myTheme.greySecondary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
