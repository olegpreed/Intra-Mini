import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/project_item.dart';
import 'package:forty_two_planet/pages/profile_page/components/search_project_bar.dart';
import 'package:forty_two_planet/pages/profile_page/components/cursus_switcher.dart';
import 'package:forty_two_planet/pages/profile_page/components/project_list_close_btn.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';

class ProfileProjects extends StatefulWidget {
  const ProfileProjects(
      {super.key,
      required this.userData,
      required this.isLoading,
      required this.isShimmerFinished});
  final UserData userData;
  final bool isLoading;
  final bool isShimmerFinished;

  @override
  State<ProfileProjects> createState() => _ProfileProjectsState();
}

class _ProfileProjectsState extends State<ProfileProjects> {
  late String? _selectedCursus = '42cursus';
  List<ProjectData> _displayedProjects = [];
  final ScrollController _projectsScrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.userData.projects.isEmpty) {
      return;
    }
    if (widget.userData.projects.containsKey('42cursus')) {
      _selectedCursus = '42cursus';
    } else {
      _selectedCursus = widget.userData.projects.keys.first;
    }
    _displayedProjects = widget.userData.projects[_selectedCursus]!;
    searchController.addListener(() {
      if (searchController.text.isNotEmpty) {
        _projectsScrollController.jumpTo(0);
      }
      setState(() {
        _displayedProjects = widget.userData.projects[_selectedCursus]!
            .where((project) => project.name!
                .toLowerCase()
                .contains(searchController.text.toLowerCase()))
            .toList();
      });
    });
  }

  void _onCursusChanged(String? selected) {
    setState(() {
      _selectedCursus = selected;
      _displayedProjects = widget.userData.projects[_selectedCursus]!;
    });
  }

  void onCloseList() {
    setState(() {
      searchController.clear();
      _projectsScrollController.jumpTo(0);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _projectsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double foldedHeight = Layout.cellWidth * 2.3;
    ProjectListState projectsListProvider =
        Provider.of<ProjectListState>(context);
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          height: projectsListProvider.isExpanded ? 0 : foldedHeight,
        ),
        AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.only(
              left: Layout.padding,
              right: Layout.padding,
              bottom: !projectsListProvider.isExpanded ? 10 : 0),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            opacity: !widget.isShimmerFinished ? 0 : 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AnimatedCrossFade(
                    crossFadeState: projectsListProvider.isExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 300),
                    secondChild: SearchProjectBar(controller: searchController),
                    firstChild: Text(widget.isLoading ? '' : 'Projects',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(color: context.myTheme.greyMain)),
                  ),
                ),
                AnimatedCrossFade(
                  crossFadeState: projectsListProvider.isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  secondChild: ProjectListCloseBtn(onPressed: onCloseList),
                  firstChild: widget.isLoading
                      ? Container()
                      : CursusSwitcher(
                          selectedCursus: _selectedCursus,
                          onCursusChanged: _onCursusChanged,
                          cursusList: widget.userData.projects.keys.toList(),
                        ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: Layout.padding),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: !widget.isShimmerFinished ? 0 : 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _projectsScrollController,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 70 + Layout.screenHeight * 0.05,
                            top: Layout.gutter * 2),
                        child: Column(
                          children: _displayedProjects.map((project) {
                            return ProjectItem(
                                projectData: project,
                                userId: widget.userData.id!,
                                isLast: project == _displayedProjects.last);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  if (!projectsListProvider.isExpanded)
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onVerticalDragUpdate: (details) => {
                        if (details.primaryDelta! < 0 && !widget.isLoading)
                          {projectsListProvider.expand()}
                      },
                    )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ProjectListState extends ChangeNotifier {
  bool isExpanded = false;

  void expand() {
    isExpanded = true;
    notifyListeners();
  }

  void collapse() {
    isExpanded = false;
    notifyListeners();
  }
}
