import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/ui_uitls.dart';

class LogFillColumn extends StatefulWidget {
  const LogFillColumn(
      {super.key,
      required this.logtime,
      required this.ratio,
      required this.firstWeek,
      required this.lastWeek});
  final double logtime;
  final double ratio;
  final bool firstWeek;
  final bool lastWeek;

  @override
  State<LogFillColumn> createState() => _LogFillColumnState();
}

class _LogFillColumnState extends State<LogFillColumn>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
            begin: 0, end: (widget.logtime / 60 > 1 ? 1 : widget.logtime / 60))
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant LogFillColumn oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.logtime != widget.logtime) {
      _heightAnimation = Tween<double>(
              begin: 0,
              end: (widget.logtime / 60 > 1 ? 1 : widget.logtime / 60))
          .animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ),
      );

      _controller.forward(
          from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return FractionallySizedBox(
          heightFactor: _heightAnimation.value,
          child: Container(
            width: Layout.cellWidth / 5.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: widget.lastWeek
                    ? Alignment.bottomCenter
                    : Alignment.topCenter,
                end: widget.lastWeek
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                stops: [widget.ratio, widget.ratio],
                colors: [
                  context.myTheme.intra.withOpacity(1),
                  context.myTheme.intra.withOpacity(0.4)
                ],
              ),
              color: context.myTheme.intra,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
