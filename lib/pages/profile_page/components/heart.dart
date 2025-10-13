import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/components/pressable_scale.dart';
import 'package:forty_two_planet/services/favourites_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class Heart extends StatefulWidget {
  const Heart({super.key, required this.userId});
  final int userId;

  @override
  State<Heart> createState() => _HeartState();
}

class _HeartState extends State<Heart> {
  bool isFavorited = false;
  @override
  void initState() {
    super.initState();
    _checkIfFavorited();
  }

  void _checkIfFavorited() async {
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    int myId = profileStore.userData.id!;
    bool fav = await FavouriteStorage.isFavourite(
        myId.toString(), widget.userId.toString());
    setState(() {
      isFavorited = fav;
    });
  }

  void onTap() async {
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    int myId = profileStore.userData.id!;
    if (isFavorited) {
      await FavouriteStorage.removeFavourite(
          myId.toString(), widget.userId.toString());
    } else {
      await FavouriteStorage.addFavourite(
          myId.toString(), widget.userId.toString());
    }
    profileStore.setFavouriteIds(
        await FavouriteStorage.loadFavourites(myId.toString()));
    setState(() {
      isFavorited = !isFavorited;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onPressed: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: Layout.gutter),
        child: AnimatedCrossFade(
          firstChild: SvgPicture.asset(
            'assets/icons/heart_full.svg',
            colorFilter:
                ColorFilter.mode(context.myTheme.fail, BlendMode.srcIn),
          ),
          secondChild: SvgPicture.asset(
            'assets/icons/heart_empty.svg',
            colorFilter: ColorFilter.mode(
                context.myTheme.greySecondary, BlendMode.srcIn),
          ),
          crossFadeState: isFavorited
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
      ),
    );
  }
}
