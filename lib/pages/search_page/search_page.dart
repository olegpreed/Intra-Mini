import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/search_page/components/cadet_card.dart';
import 'package:forty_two_planet/pages/search_page/components/level_slider.dart';
import 'package:forty_two_planet/pages/search_page/components/my_search_bar.dart';
import 'package:forty_two_planet/pages/search_page/components/my_toggle_btn.dart';
import 'package:forty_two_planet/pages/search_page/components/project_status_slider.dart';
import 'package:forty_two_planet/pages/search_page/components/refresh_button.dart';
import 'package:forty_two_planet/components/sort_btn.dart';
import 'package:forty_two_planet/data/project_ids.dart';
import 'package:forty_two_planet/pages/profile_page/profile_page.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();
  bool onlyOnline = false;
  bool newCadetsFirst = true;
  RangeValues levelValues = const RangeValues(0, 21);
  bool isLoading = false;
  bool isSearchingCadet = false;
  List<UserData> cadets = [];
  Map<UserData, SearchProjectData> projectCadets = {};
  int currentPage = 1;
  List<int> totalPages = [1];
  String? projectName;
  String? projectStatus = 'creating_group,searching_a_group';
  int projectStatusIndex = 0;
  bool isSearchByProject = false;
  bool isProjectLoading = false;
  bool isListAnimationFinished = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    levelValues =
        Provider.of<SettingsProvider>(context, listen: false).get('levelRange');
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void changeLevelRange(RangeValues newValues) {
    Provider.of<SettingsProvider>(context, listen: false)
        .saveASetting('levelRange', newValues);
    setState(() {
      _scrollController.jumpTo(0);
      levelValues = newValues;
    });
  }

  void toggleOnline() {
    setState(() {
      onlyOnline = !onlyOnline;
    });
  }

  void toggleSort() {
    _scrollController
        .animateTo(
      0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.linear,
    )
        .then((value) {
      setState(() {
        newCadetsFirst = !newCadetsFirst;
        isListAnimationFinished = false;
      });
    });
  }

  void resetProjectFilter() {
    setState(() {
      projectName = null;
      projectCadets.clear();
    });
  }

  void sortProjectCadets() {
    setState(() {
      List<MapEntry<UserData, SearchProjectData>> entries =
          projectCadets.entries.toList();
      if (projectStatusIndex == 0) {
        entries.sort(
            (a, b) => (b.value.teamId ?? 0).compareTo(a.value.teamId ?? 0));
      } else {
        entries.sort((a, b) => (b.value.timeStamp ?? DateTime(0))
            .compareTo(a.value.timeStamp ?? DateTime(0)));
      }
      projectCadets = Map.fromEntries(entries);
    });
  }

  void searchCadet(String cadetName) async {
    UserData cadetData = UserData(login: cadetName);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProfilePage(
                cadetData: cadetData,
                isHomeView: false,
              )),
    );
  }

  void switchSearch() {
    setState(() {
      isSearchByProject = !isSearchByProject;
    });
  }

  void onSelectedProjectStatus(int index) {
    if (isProjectLoading || index == projectStatusIndex) {
      return;
    }
    setState(() {
      projectStatusIndex = index;
      projectStatus = projectStatusIndex == 0
          ? 'creating_group,searching_a_group'
          : index == 1
              ? 'in_progress'
              : 'finished';
      projectCadets.clear();
    });
    if (projectName != null) {
      loadProjectCadets();
    }
  }

  void onSelected(String selection) {
    setState(() {
      projectName = selection;
    });
    loadProjectCadets();
  }

  void loadProjectCadets() async {
    setState(() {
      isProjectLoading = true;
      isListAnimationFinished = false;
    });
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    Map<UserData, SearchProjectData> cadetsFromPage = {};
    try {
      cadetsFromPage = await CampusDataService.fetchProjectCadets(
        profileStore.userData.campusData!.id!,
        projectsByIds[projectName]!,
        projectStatus!,
      );
    } catch (e) {
      await showErrorDialog(e.toString());
      setState(() {
        isProjectLoading = false;
      });
      return;
    }
    setState(() {
      projectCadets.addAll(cadetsFromPage);
      isProjectLoading = false;
      sortProjectCadets();
    });
  }

  void loadCadets() async {
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    cadets.clear();
    setState(() {
      isLoading = true;
      isListAnimationFinished = false;
      currentPage = 1;
      totalPages[0] = 1;
    });
    try {
      while (currentPage <= totalPages[0] && isLoading) {
        final cadetsFromPage = await CampusDataService.fetchCampusCadets(
            profileStore.userData.campusData!.id!,
            currentPage,
            totalPages,
            levelValues);
        currentPage++;

        if (mounted && isLoading) {
          setState(() {
            cadets.addAll(cadetsFromPage);
          });
        }
      }
    } catch (e) {
      await showErrorDialog(e.toString());
    }
    await Future.delayed(const Duration(seconds: 1));
    if (mounted && isLoading) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void cancelLoadCadets() {
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchText = controller.text.toLowerCase();
    List<UserData> fromCadets =
        isSearchByProject ? projectCadets.keys.toList() : cadets;
    List<UserData> filteredCadets = fromCadets.where((cadet) {
      bool matchesSearch = true;
      bool matchesOnline = !onlyOnline || cadet.location != null;
      bool matchesLevel = true;
      if (!isSearchByProject) {
        matchesLevel = cadet.cursusLevels[21]!.floor() >= levelValues.start &&
            cadet.cursusLevels[21]!.floor() <= levelValues.end;
        matchesSearch = cadet.login!.toLowerCase().startsWith(searchText);
      }
      return matchesSearch && matchesOnline && matchesLevel;
    }).toList();

    if (!newCadetsFirst) {
      filteredCadets = filteredCadets.reversed.toList();
    }
    RangeLabels labels = RangeLabels(
      levelValues.start.toStringAsFixed(0),
      levelValues.end.toStringAsFixed(0),
    );
    return Stack(children: [
      Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                child: Column(
                  children: [
                    SizedBox(height: Layout.gutter * 2),
                    MySearchBar(
                      controller: controller,
                      isSearchByProject: isSearchByProject,
                      onSelected: onSelected,
                      onChangeSearchType: switchSearch,
                      onProjectClose: resetProjectFilter,
                      onSearch: searchCadet,
                      isSearchingCadet: isSearchingCadet,
                      isProjectLoading: isProjectLoading,
                    ),
                    SizedBox(height: Layout.gutter * 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        MyToggleBtn(
                          text: 'onsite',
                          onPressed: toggleOnline,
                          isPressed: onlyOnline,
                        ),
                        SizedBox(width: Layout.padding / 2),
                        Expanded(
                          child: !isSearchByProject
                              ? LevelSlider(
                                  changeLevelRange: changeLevelRange,
                                  labels: labels,
                                  levelValues: levelValues)
                              : ProjectSliderStatus(
                                  index: projectStatusIndex,
                                  onPressed: onSelectedProjectStatus,
                                ),
                        ),
                        SizedBox(width: Layout.padding / 2),
                        SortBtn(
                          onPressed: toggleSort,
                          isAscending: newCadetsFirst,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Layout.padding,
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: Layout.gutter),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Layout.padding),
            child: Column(
              children: [
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: isLoading && !isSearchByProject
                      ? TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          tween: Tween<double>(
                            begin: 0,
                            end: (currentPage - 1) / totalPages[0],
                          ),
                          builder: (context, value, _) =>
                              LinearProgressIndicator(
                            value: value,
                            backgroundColor:
                                context.myTheme.intra.withOpacity(0.1),
                            color: context.myTheme.intra,
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(30),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                if (isSearchByProject &&
                    projectCadets.isEmpty &&
                    !isProjectLoading &&
                    projectName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text('Not found',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(color: context.myTheme.greyMain)),
                  ),
              ],
            ),
          ),
          Expanded(
            child: RawScrollbar(
              padding: EdgeInsets.only(
                  right: 5,
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                  top: 10),
              thumbColor: context.myTheme.greyMain.withOpacity(0.3),
              radius: const Radius.circular(30),
              controller: _scrollController,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(top: 7, bottom: 200),
                  itemCount: filteredCadets.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(
                          milliseconds: isListAnimationFinished ? 0 : 500),
                      onEnd: () {
                        isListAnimationFinished = true;
                      },
                      builder: (context, opacity, child) {
                        return Opacity(
                          opacity: opacity,
                          child: child,
                        );
                      },
                      child: CadetCard(
                        key: ValueKey(filteredCadets[index].id),
                        cadetData: filteredCadets[index],
                        projectData: isSearchByProject
                            ? projectCadets[filteredCadets[index]]
                            : null,
                        projectStatus: isSearchByProject ? projectStatus : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      RefreshButton(
        onPressed: isLoading ? cancelLoadCadets : loadCadets,
        isLoading: isLoading,
        isSearchByProject: isSearchByProject,
      ),
    ]);
  }
}
