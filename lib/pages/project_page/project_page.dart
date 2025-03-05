import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/project_page/components/team_card.dart';
import 'package:forty_two_planet/pages/project_page/components/project_header.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({
    super.key,
    this.projectId,
    this.userId,
    this.projectName,
  });
  final int? projectId;
  final int? userId;
  final String? projectName;

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool _areTeamsLoading = true;
  List<TeamData> _teams = [];
  int selectedTeamIndex = -1;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    try {
      _teams = await UserService.fetchProjectTeams(
          widget.projectId!, widget.userId!);
    } catch (e) {
      showErrorDialog(e.toString());
      Navigator.of(context).pop();
    }
    setState(() {
      _areTeamsLoading = false;
    });
  }

  void _onTeamTap(int index) {
    _scrollController.jumpTo(0);
    setState(() {
      selectedTeamIndex = index;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Layout.padding),
          child: Column(
            children: [
              ProjectHeader(
                projectName: widget.projectName,
                selectedTeamIndex: selectedTeamIndex,
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 200),
                    child: Column(
                      children: [
                        if (_areTeamsLoading)
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: LoadingIndicator(
                                indicatorType: Indicator.lineSpinFadeLoader,
                                colors: [context.myTheme.greySecondary],
                              ),
                            ),
                          )
                        else
                          for (var team in _teams)
                            TeamCard(
                              team: team,
                              projectId: widget.projectId!,
                              index: _teams.indexOf(team),
                              selectedIndex: selectedTeamIndex,
                              onTap: _onTeamTap,
                            ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
