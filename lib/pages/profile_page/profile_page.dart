import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_header.dart';
import 'package:forty_two_planet/components/shimmer.dart';
import 'package:forty_two_planet/components/shimmer_loading.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_projects.dart';
import 'package:forty_two_planet/pages/profile_page/components/profile_widgets.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
    required this.cadetData,
    required this.isHomeView,
  });
  final UserData cadetData;
  final bool isHomeView;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  bool _isShimmerFinished = false;
  UserData _userData = UserData();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    _userData = widget.cadetData;
    if (!widget.isHomeView) {
      try {
        await _fetchProfileData();
      } catch (e) {
        Navigator.of(context).pop();
        await showErrorDialog(e.toString());
      }
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      setState(() {
        _isShimmerFinished = true;
      });
    });
  }

  Future<void> _fetchProfileData() async {
    _userData = await UserService.fetchProfile(
        isHomeView: false, userId: widget.cadetData.login);
    if (!mounted) return;
    _userData.coalitionColor =
        await UserService.fetchCoalitionColor(_userData.login!);
    if (!mounted) return;
    _userData.lastSeen = await UserService.fetchLastSeen(_userData.login!);
    if (!mounted) return;
    _userData.weeklyLogTimesByMonth =
        await UserService.fetchMonthLogtime(_userData.login!);
    if (!mounted) return;
    if (_userData.imageUrlBig != null) {
      await precacheImage(NetworkImage(_userData.imageUrlBig!), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProjectListState(),
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Shimmer(
            linearGradient: shimmerGradient([
              Theme.of(context).cardColor,
              context.myTheme.shimmer,
              Theme.of(context).cardColor,
            ]),
            child: ShimmerLoading(
              isLoading: _isLoading,
              child: Padding(
                padding: EdgeInsets.only(
                    top: Layout.hasScreenBuffers ? 0 : Layout.gutter),
                child: Column(
                  children: [
                    ProfileHeader(
                        isLoading: _isLoading,
                        userData: _userData,
                        isHomeView: widget.isHomeView,
                        isShimmerFinished: _isShimmerFinished),
                    Expanded(
                      child: Stack(
                        children: [
                          ProfileWidgets(
                            userData: _userData,
                            isLoading: _isLoading,
                            isShimmerFinished: _isShimmerFinished,
                          ),
                          Positioned.fill(
                              child: ProfileProjects(
                            userData: _userData,
                            isLoading: _isLoading,
                            isShimmerFinished: _isShimmerFinished,
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
