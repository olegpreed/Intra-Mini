import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class TimeAgoWidget extends StatefulWidget {
  final DateTime dateTime;

  const TimeAgoWidget({super.key, required this.dateTime});

  @override
  _TimeAgoWidgetState createState() => _TimeAgoWidgetState();
}

class _TimeAgoWidgetState extends State<TimeAgoWidget> {
  late Timer _timer;
  late String _timeAgo;

  @override
  void initState() {
    super.initState();
    _updateTimeAgo();
    // Update the time every minute
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _updateTimeAgo();
    });
  }

  void _updateTimeAgo() {
    setState(() {
      _timeAgo = timeAgo(widget.dateTime);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('($_timeAgo)',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: context.myTheme.greyMain));
  }
}

// The timeAgo function defined above
String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.isNegative) {
    final futureDifference = dateTime.difference(now);

    if (futureDifference.inMinutes < 1) {
      return 'now';
    } else if (futureDifference.inMinutes < 60) {
      return 'in ${futureDifference.inMinutes}min';
    } else if (futureDifference.inHours < 24) {
      return 'in ${futureDifference.inHours}h';
    } else {
      return 'in ${futureDifference.inDays}d';
    }
  } else {
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
