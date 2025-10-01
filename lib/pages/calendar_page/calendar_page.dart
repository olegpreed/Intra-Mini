import 'package:flutter/material.dart';
import 'package:forty_two_planet/pages/calendar_page/components/add_slot_button.dart';
import 'package:forty_two_planet/pages/calendar_page/components/bottom_sheet.dart';
import 'package:forty_two_planet/pages/calendar_page/components/calendar.dart';
import 'package:forty_two_planet/pages/calendar_page/components/event_card.dart';
import 'package:forty_two_planet/pages/calendar_page/components/event_info.dart';
import 'package:forty_two_planet/pages/calendar_page/components/loading_events.dart';
import 'package:forty_two_planet/pages/calendar_page/components/events_header.dart';
import 'package:forty_two_planet/pages/calendar_page/components/switch_text_button.dart';
import 'package:forty_two_planet/pages/calendar_page/components/slot_card.dart';
import 'package:forty_two_planet/pages/calendar_page/components/time_slot_picker.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/settings/user_settings.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/fake_data_utils.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  bool isLoading = true;
  bool isEvents = true;
  bool isBottomExpanded = false;
  DateTime? selectedDay;
  Event? selectedEvent;

  @override
  void initState() {
    super.initState();
    fetchData().then((value) => setState(() => isLoading = false));
  }

  Future fetchData() async {
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    final campusStore = Provider.of<CampusStore>(context, listen: false);
    final includeExams =
        Provider.of<SettingsProvider>(context, listen: false).get('fetchExams');
    try {
      if (isLoading || (!isLoading && isEvents)) {
        final eventIds = await UserService.fetchSubscribedEventIds(
            profileStore.userData.id!);
        profileStore.setEventIds(eventIds);
        final events = await CampusDataService.fetchEvents(
            profileStore.userData.currentCampusId!, includeExams);
        campusStore.setEvents(events);
      }
      if (isLoading || (!isLoading && !isEvents)) {
        final slotsData = await UserService.fetchSlots();
        profileStore.setSlots(slotsData);
      }
    } catch (e) {
      showErrorDialog(e.toString());
      return;
    }
  }

  void resetDate() {
    setState(() {
      selectedDay = null;
    });
  }

  Future<void> putSlot(DateTime start, DateTime end) async {
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    int userId = profileStore.userData.id!;
    try {
      await UserService.putSlot(userId, start, end);
    } catch (e) {
      showErrorDialog(e.toString());
      return;
    }
    try {
      final slotsData = await UserService.fetchSlots();
      profileStore.setSlots(slotsData);
    } catch (e) {
      showErrorDialog(e.toString());
    }
    setState(() {
      isBottomExpanded = false;
      selectedDay = null;
    });
  }

  void openTimePicker() {
    setState(() {
      selectedDay ??= DateTime.now();
      isBottomExpanded = true;
    });
  }

  void swapEventsSlots(index) {
    setState(() {
      isEvents = index == 0;
      selectedDay = null;
      isBottomExpanded = false;
      selectedEvent = null;
    });
  }

  void onEventSelected(Event event) {
    setState(() {
      isBottomExpanded = true;
      selectedEvent = event;
      selectedDay = null;
    });
  }

  void closeBottomSheet() {
    setState(() {
      isBottomExpanded = false;
      selectedEvent = null;
      selectedDay = null;
    });
  }

  void selectDay(DateTime? date) {
    if (!isBottomExpanded) {
      setState(() {
        selectedDay = date;
      });
    }
  }

  List<Event> get filteredEvents {
    final campusStore = Provider.of<CampusStore>(context, listen: false);
    if (selectedDay == null) return campusStore.events;
    return campusStore.events
        .where((event) => isSameDay(event.beginAt, selectedDay))
        .toList();
  }

  List<Slot> get filteredSlots {
    final profileStore = Provider.of<MyProfileStore>(context, listen: false);
    if (selectedDay == null) return profileStore.slots;
    return profileStore.slots
        .where((slot) => isSameDay(slot.beginAt, selectedDay))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final allEvents = Provider.of<CampusStore>(context).events;
    final allSlots = Provider.of<MyProfileStore>(context).slots;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Layout.padding),
            child: Column(
              children: [
                SwitchTextButton(
                    onPressed: swapEventsSlots,
                    leftText: 'Events',
                    rightText: 'Slots'),
                MyCalendar(
                    onTap: selectDay,
                    isExpanded: isBottomExpanded,
                    isEvents: isEvents,
                    events: isEvents ? allEvents : allSlots,
                    startDate: selectedEvent?.beginAt,
                    endDate: selectedEvent?.endAt,
                    format: isBottomExpanded
                        ? CalendarFormat.week
                        : CalendarFormat.twoWeeks,
                    focusedDay: selectedEvent?.beginAt,
                    selectedDay: selectedDay),
              ],
            ),
          ),
          Expanded(
              child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Layout.padding),
                child: Column(
                  children: [
                    if (!isBottomExpanded || isBottomExpanded && isEvents)
                      EventsHeader(
                          selectedDay: selectedDay,
                          isEvents: isEvents,
                          onClose: resetDate),
                    if (!isBottomExpanded && !isEvents)
                      AddSlotButton(onTap: openTimePicker),
                    Expanded(
                      child: isLoading
                          ? const LoadingEvents()
                          : RefreshIndicator(
                              backgroundColor: Theme.of(context).cardColor,
                              color: context.myTheme.greyMain,
                              strokeWidth: 3,
                              onRefresh: fetchData,
                              displacement: 0,
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 100),
                                  child: Column(children: [
                                    if (isEvents)
                                      for (var event in filteredEvents)
                                        EventCard(
                                          event: event,
                                          onEventSelected: onEventSelected,
                                        )
                                    else
                                      for (var slot in filteredSlots)
                                        SlotCard(slot: slot)
                                  ]),
                                ),
                              ),
                            ),
                    )
                  ],
                ),
              ),
              if (isBottomExpanded)
                BottomCalendarSheet(
                    color: !isEvents ? null : Theme.of(context).cardColor,
                    onClose: closeBottomSheet,
                    child: !isEvents
                        ? TimeSlotPicker(
                            selectedDay: selectedDay ?? DateTime.now(),
                            slots: allSlots,
                            onSlotSelected: putSlot,
                          )
                        : EventInfo(event: selectedEvent!)),
            ],
          )),
        ],
      ),
    );
  }
}
