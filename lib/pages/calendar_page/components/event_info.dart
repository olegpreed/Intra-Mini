import 'package:flutter/material.dart';
import 'package:forty_two_planet/components/icon_text.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/text_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class EventInfo extends StatefulWidget {
  const EventInfo({super.key, required this.event});
  final Event event;

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  bool isLoading = false;

  String getEventTime(DateTime? beginAt, DateTime? endAt) {
    if (beginAt == null || endAt == null) {
      return '';
    }
    final DateFormat formatter = DateFormat('h:mma');
    if (beginAt.day != endAt.day) {
      return formatter.format(beginAt);
    }
    return '${formatter.format(beginAt)} - ${formatter.format(endAt)}';
  }

  void eventAction(bool isSubscribed) async {
    setState(() {
      isLoading = true;
    });
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    CampusStore campusStore = Provider.of<CampusStore>(context, listen: false);
    final includeExams =
        Provider.of<SettingsProvider>(context, listen: false).get('fetchExams');
    int myId = profileStore.userData.id!;
    try {
      if (isSubscribed) {
        int unsubscribeId = profileStore.eventIds[widget.event.id!]!;
        await UserService.unsubscribeFromEvent(unsubscribeId);
      } else {
        await UserService.subscribeToEvent(widget.event.id!, myId);
      }
      final campusEvents = await CampusDataService.fetchEvents(
          profileStore.userData.campusId!, includeExams);
      campusStore.setEvents(campusEvents);
      Map<int, int> updatedEventIds =
          await UserService.fetchSubscribedEventIds(myId);
      profileStore.setEventIds(updatedEventIds);
    } catch (e) {
      showErrorDialog(e.toString());
    }
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSubscribed = Provider.of<MyProfileStore>(context, listen: true)
        .eventIds
        .containsKey(widget.event.id);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              left: Layout.padding, right: Layout.padding, top: 35),
          child: Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(
                text: '${widget.event.name} ',
                style: Theme.of(context).textTheme.headlineLarge,
                children: <TextSpan>[
                  TextSpan(
                    text:
                        '(${widget.event.subscrCount}/${widget.event.maxPeople})',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: context.myTheme.greyMain,
                        ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Stack(children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Layout.padding),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.event.isExam)
                    GestureDetector(
                      onTap: () => eventAction(isSubscribed),
                      behavior: HitTestBehavior.translucent,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 30,
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width *
                              0.3, // Set minimum width
                        ),
                        decoration: BoxDecoration(
                          color: isSubscribed
                              ? context.myTheme.fail.withOpacity(0.4)
                              : context.myTheme.intra.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: isLoading
                              ? FractionallySizedBox(
                                  heightFactor: 0.7,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.lineSpinFadeLoader,
                                    colors: [
                                      isSubscribed
                                          ? context.myTheme.fail
                                          : context.myTheme.intra
                                    ],
                                  ),
                                )
                              : Text(isSubscribed ? 'unsubscribe' : 'subscribe',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: isSubscribed
                                            ? context.myTheme.fail
                                            : context.myTheme.intra,
                                        // : Theme.of(context).primaryColor,
                                      )),
                        ),
                      ),
                    ),
                  if (!widget.event.isExam) const SizedBox(width: 10),
                  IconText(
                      svgPath: 'assets/icons/clock.svg',
                      text: getEventTime(
                          widget.event.beginAt, widget.event.endAt)),
                  const SizedBox(width: 10),
                  IconText(
                      svgPath: 'assets/icons/pin.svg',
                      text: '${widget.event.location}'),
                ],
              ),
            ),
          ),
        ]),
        const SizedBox(height: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Layout.padding),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 90),
                child: ClickableText(text: widget.event.description ?? ''),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
