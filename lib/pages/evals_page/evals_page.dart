import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:forty_two_planet/components/generic_header.dart';
import 'package:forty_two_planet/pages/project_page/components/feedback_chat.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:loading_indicator/loading_indicator.dart';

class EvalsPage extends StatefulWidget {
  const EvalsPage({super.key, required this.userId});
  final int userId;

  @override
  State<EvalsPage> createState() => _EvalsPageState();
}

class _EvalsPageState extends State<EvalsPage> {
  List<FeedbackData> feedbacks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvalsData();
  }

  void _fetchEvalsData() async {
    feedbacks = await UserService.fetchUserFeedbacks(widget.userId);
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Layout.padding),
          child: Column(children: [
            const GenericHeader(title: 'Evaluations'),
            const SizedBox(height: 20),
            Expanded(
              child: isLoading
                  ? Center(
                      child: SizedBox(
                      width: 20,
                      height: 20,
                      child: LoadingIndicator(
                        indicatorType: Indicator.lineSpinFadeLoader,
                        colors: [context.myTheme.greyMain],
                      ),
                    ))
                  : FadeIn(
                      duration: const Duration(milliseconds: 300),
                      child: ListView.separated(
                        itemCount: feedbacks.length,
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(bottom: Layout.gutter),
                          child: Divider(
                            thickness: 2,
                            color: context.myTheme.greySecondary.withAlpha(80),
                          ),
                        ),
                        itemBuilder: (context, index) {
                          FeedbackData feedback = feedbacks[index];
                          return FeedbackChat(
                              feedback: feedback, isProjectView: false);
                        },
                      ),
                    ),
            ),
          ]),
        ),
      ),
    );
  }
}
