import 'package:flutter/material.dart';
import 'package:forty_two_planet/components/icon_text.dart';
import 'package:forty_two_planet/main.dart';
import 'package:forty_two_planet/pages/calendar_page/components/notify_button.dart';
import 'package:forty_two_planet/pages/calendar_page/components/subscribe_btn.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/text_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventInfo extends StatefulWidget {
  const EventInfo({super.key, required this.event});
  final Event event;

  @override
  State<EventInfo> createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  bool isLoading = false;
  bool isNotified = false;

  @override
  void initState() {
    super.initState();
    checkIfNotified();
  }

  void checkIfNotified() async {
    final pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();

    final exists = pendingNotifications.any((n) => n.id == widget.event.id);
    if (!mounted) return;
    setState(() {
      isNotified = exists;
    });
  }

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
          profileStore.userData.currentCampusId!, includeExams);
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
    bool isSubscribed = !widget.event.isExam &&
        Provider.of<MyProfileStore>(context, listen: true)
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
                        '(${widget.event.subscrCount}/${widget.event.maxPeople ?? '∞'})',
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
        SizedBox(height: Layout.gutter),
        Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SubscribeBtn(
                      isLoading: isLoading,
                      isExam: widget.event.isExam,
                      isSubscribed: isSubscribed,
                      onPressed: !widget.event.isExam
                          ? () => eventAction(isSubscribed)
                          : () => launchUrl(
                              Uri.parse(
                                  'https://profile.intra.42.fr/exams/${widget.event.id}'),
                              mode: LaunchMode.inAppBrowserView)),
                  const SizedBox(width: 10),
                  NotifyButton(
                      event: widget.event,
                      isNotified: isNotified,
                      onOk: () {
                        setState(() {
                          isNotified = true;
                        });
                      },
                      onCancel: () {
                        setState(() {
                          isNotified = false;
                        });
                      }),
                ],
              ),
              SizedBox(height: Layout.gutter),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
            ],
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
                child: ClickableText(
                    text: widget.event.description ?? '',
                    style: Theme.of(context).textTheme.bodyMedium!),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
