import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RefreshButton extends StatefulWidget {
  const RefreshButton(
      {super.key,
      required this.isLoading,
      required this.onPressed,
      required this.isSearchByProject});
  final bool isLoading;
  final Function onPressed;
  final bool isSearchByProject;

  @override
  State<RefreshButton> createState() => _RefreshButtonState();
}

class _RefreshButtonState extends State<RefreshButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isLoading != widget.isLoading) {
      if (!widget.isLoading) {
        _controller.animateTo(
          1.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      } else {
        _controller.repeat();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double extraMargin = MediaQuery.of(context).padding.bottom == 0
        ? MediaQuery.of(context).size.height * 0.01
        : 0;
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              if (widget.isLoading) {
                _controller.stop();
              } else {
                _controller.repeat();
              }
              widget.onPressed();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              margin: !widget.isSearchByProject
                  ? EdgeInsets.only(bottom: 80 + extraMargin)
                  : EdgeInsets.only(bottom: 0 + extraMargin),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(35),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: 176,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(35),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: AnimatedBuilder(
                            animation: _animation,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: _animation.value * 2 * 3.141592653589793,
                                child: child,
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/icons/refresh.svg',
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.17,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              widget.isLoading ? 'Cancel' : 'Refresh',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
