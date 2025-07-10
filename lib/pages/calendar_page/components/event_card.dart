import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  const EventCard(
      {super.key, required this.event, required this.onEventSelected});
  final Event event;
  final void Function(Event) onEventSelected;

  @override
  Widget build(BuildContext context) {
    bool isSubscribed = Provider.of<MyProfileStore>(context, listen: true)
        .eventIds
        .containsKey(event.id);
    return GestureDetector(
      onTap: () => onEventSelected(event),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.only(left: 16, right: 6, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.name ?? '',
                    style: Theme.of(context).textTheme.bodyMedium,
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        event.isExam ? 'Exam' : event.kind ?? '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: context.myTheme.greyMain,
                            ),
                      ),
                      if (isSubscribed)
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.03,
                            child: SvgPicture.asset(
                              'assets/icons/success.svg',
                              colorFilter: ColorFilter.mode(
                                context.myTheme.greyMain,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.width * 0.18,
              width: MediaQuery.of(context).size.width * 0.18,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border.all(
                  strokeAlign: BorderSide.strokeAlignInside,
                  color:
                      event.isExam ? context.myTheme.fail : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('d MMM').format(event.beginAt ?? DateTime.now()),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    child: Text(
                      DateFormat('h:mma')
                          .format(event.beginAt ?? DateTime.now()),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
