import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forty_two_planet/components/navbar.dart';
import 'package:forty_two_planet/pages/calendar_page/calendar_page.dart';
import 'package:forty_two_planet/pages/profile_page/profile_page.dart';
import 'package:forty_two_planet/pages/search_page/search_page.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:transitioned_indexed_stack/transitioned_indexed_stack.dart';

class Home extends StatefulWidget {
  const Home(
      {super.key,
      required this.didFinishProfileTutorial,
      required this.didFinishSearchTutorial});
  final bool didFinishProfileTutorial;
  final bool didFinishSearchTutorial;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  bool _isPageLoaded = false;
  List<GlobalKey> searchPageKeys = List.generate(6, (_) => GlobalKey());
  bool didFinishSearchTutorial = false;

  @override
  void initState() {
    super.initState();
    ShowcaseView.register(
      onComplete: (showcaseIndex, key) async {
        final prefs = await SharedPreferences.getInstance();
        if (showcaseIndex == 5 && key == searchPageKeys[5]) {
          setState(() {
            didFinishSearchTutorial = true;
          });
          await prefs.setBool('didFinishSearchTutorial', true);
        } else if (showcaseIndex == 7) {
          await prefs.setBool('didFinishProfileTutorial', true);
        }
      },
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        setState(() {
          _isPageLoaded = true;
        });
      });
    });
  }

  @override
  void dispose() {
    ShowcaseView.get().unregister();
    super.dispose();
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    3,
    (_) => GlobalKey<NavigatorState>(),
  );

  void _onNavItemTapped(int index, int selectedIndex) {
    HapticFeedback.selectionClick();
    if (index == 1 &&
        (!widget.didFinishSearchTutorial && !didFinishSearchTutorial)) {
      ShowcaseView.get().startShowCase(searchPageKeys);
    }
    if (index == selectedIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
      return;
    }
  }

  List<Widget> buildNavigatorsFromPages(List<Widget> pages) {
    return List.generate(pages.length, (index) {
      return Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => pages[index],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pageProvider = Provider.of<PageProvider>(context);
    List<Widget> pages = [
      ProfilePage(
        isHomeView: true,
        cadetData: Provider.of<MyProfileStore>(context).userData,
        didFinishProfileTutorial: widget.didFinishProfileTutorial,
      ),
      SearchPage(showcaseKeys: searchPageKeys),
      const CalendarPage(),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        final currentNavigator =
            _navigatorKeys[pageProvider.selectedIndex].currentState;
        if (currentNavigator != null && currentNavigator.canPop()) {
          currentNavigator.pop();
          return;
        }
        if (pageProvider.selectedIndex != 0) {
          pageProvider.setSelectedIndex(0);
          return;
        }
        SystemNavigator.pop();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            FadeIndexedStack(
              // IndexedStack preserves the state of each page
              beginOpacity: 0.75,
              endOpacity: 1.0,
              index: pageProvider.selectedIndex,
              children: buildNavigatorsFromPages(pages),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                offset: (_isPageLoaded && !pageProvider._isSettingsPage)
                    ? const Offset(0, 0)
                    : const Offset(0, 1),
                child: MyNavBar(
                  selectedIndex: pageProvider.selectedIndex,
                  onItemTapped: (int index) {
                    _onNavItemTapped(index, pageProvider.selectedIndex);
                    pageProvider.setSelectedIndex(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PageProvider with ChangeNotifier {
  int _selectedIndex = 0;
  bool _isSettingsPage = false;

  int get selectedIndex => _selectedIndex;
  bool get isSettingsPage => _isSettingsPage;

  void setIsSettingsPage(bool value) {
    if (_isSettingsPage != value) {
      _isSettingsPage = value;
      notifyListeners();
    }
  }

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}
