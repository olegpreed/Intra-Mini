import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/profile_page/components/skill_pillar.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class Skill {
  final String shortName;
  final String emoji;
  Skill({required this.shortName, required this.emoji});
}

class SkillsWidget extends StatefulWidget {
  const SkillsWidget(
      {super.key,
      required this.isCurrentPage,
      required this.skills,
      required this.isShimmerFinished,
      required this.isLoading});
  final Map<String, double> skills;
  final bool isShimmerFinished;
  final bool isLoading;
  final bool isCurrentPage;

  @override
  State<SkillsWidget> createState() => _SkillsWidgetState();
}

class _SkillsWidgetState extends State<SkillsWidget> {
  final Map<String, Skill> convertedSkills = {
    'Adaptation & creativity': Skill(shortName: 'Creativity', emoji: '💡'),
    'Algorithms & AI': Skill(shortName: 'Algorithms\n& AI', emoji: '🤖'),
    'Basics': Skill(shortName: 'Basics', emoji: '🧱'),
    'Company experience': Skill(shortName: 'Company\nexperience', emoji: '💼'),
    'DB & Data': Skill(shortName: 'DB\n& Data', emoji: '☁️'),
    'Functional programming':
        Skill(shortName: 'Functional\nprogramming', emoji: '🔁'),
    'Graphics': Skill(shortName: 'Graphics', emoji: '🎨'),
    'Group & interpersonal':
        Skill(shortName: 'Group\n& interpersonal', emoji: '👥'),
    'Imperative programming':
        Skill(shortName: 'Imperative\nprogramming', emoji: '🔢'),
    'Network & system administration':
        Skill(shortName: 'Network\n& sys adm', emoji: '🌐'),
    'Object-oriented programming': Skill(shortName: 'OOP', emoji: '👯‍♀️'),
    'Organization': Skill(shortName: 'Organization', emoji: '📦'),
    'Parallel computing': Skill(shortName: 'Parallel\ncomputing', emoji: '🧮'),
    'Rigor': Skill(shortName: 'Rigor', emoji: '⚒️'),
    'Ruby': Skill(shortName: 'Ruby', emoji: '💎'),
    'Security': Skill(shortName: 'Security', emoji: '🔒'),
    'Shell': Skill(shortName: 'Shell', emoji: '🐚'),
    'Technology integration':
        Skill(shortName: 'Technology\nintegration', emoji: '🔗'),
    'Unix': Skill(shortName: 'Unix', emoji: '🐧'),
    'Web': Skill(shortName: 'Web', emoji: '🌍'),
  };
  int maxSkillsOnScreen = 5;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(right: widget.skills.isEmpty ? 0 : Layout.padding),
      height: Layout.cellWidth,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Layout.cellWidth / 4),
      ),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: widget.isShimmerFinished ? 1 : 0,
        child: widget.isLoading
            ? null
            : widget.skills.isEmpty
                ? Center(
                    child: Text('No skills yet',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: context.myTheme.greyMain)),
                  )
                : Row(
                    children: [
                      Container(
                          padding: EdgeInsets.all(Layout.gutter * 2),
                          width: Layout.cellWidth,
                          height: Layout.cellWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Main Skill:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: context.myTheme.greyMain)),
                              SizedBox(height: Layout.gutter / 2),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                    convertedSkills[widget.skills.keys.first]
                                            ?.shortName ??
                                        widget.skills.keys.first,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                            color: Theme.of(context)
                                                .primaryColor)),
                              ),
                            ],
                          )),
                      Expanded(
                        child: Row(
                          children: List.generate(
                            maxSkillsOnScreen < widget.skills.length
                                ? maxSkillsOnScreen
                                : widget.skills.length,
                            (i) => SkillPillar(
                                isCurrentPage: widget.isCurrentPage,
                                skillName: widget.skills.keys.elementAt(i),
                                skillLevel: widget.skills.values.elementAt(i),
                                emoji: convertedSkills[
                                            widget.skills.keys.elementAt(i)]
                                        ?.emoji ??
                                    '🤷‍♂️'),
                          ),
                        ),
                      )
                    ],
                  ),
      ),
    );
  }
}
