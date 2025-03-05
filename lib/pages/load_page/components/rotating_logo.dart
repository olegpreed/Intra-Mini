import 'package:flutter/material.dart';

class RotatingLogo extends StatefulWidget {
  const RotatingLogo({super.key, required this.isLoading});
  final bool isLoading;

  @override
  State<RotatingLogo> createState() => _RotatingLogoState();
}

class _RotatingLogoState extends State<RotatingLogo>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation1;
  late Animation<double> _opacityAnimation2;

  @override
  void initState() {
    super.initState();

    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(
          milliseconds: 1000),
    );

    _opacityAnimation1 = Tween<double>(
      begin: 0.2,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _opacityController,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation2 = Tween<double>(
      begin: 1.0,
      end: 0.2,
    ).animate(CurvedAnimation(
      parent: _opacityController,
      curve: Curves.easeInOut,
    ));

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _controller1.repeat();
        _controller2.repeat();
        _opacityController.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller1,
          builder: (context, child) {
            return Transform.rotate(
                angle: -_controller1.value * 2 * 3.141592653589793,
                child: child);
          },
          child: AnimatedBuilder(
            animation: _opacityAnimation1,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation1.value,
                child: child,
              );
            },
            child: Stack(children: [
              Transform.translate(
                offset: const Offset(8, 8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  width: widget.isLoading ? 19 : 1,
                  height: widget.isLoading ? 19 : 1,
                  decoration: const BoxDecoration(
                    color: Color(0xFF18d2d6),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: widget.isLoading ? 100 : 19,
                height: widget.isLoading ? 100 : 19,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFF18d2d6),
                    width: 6,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ]),
          ),
        ),
        AnimatedBuilder(
          animation: _controller2,
          builder: (context, child) {
            return Transform.rotate(
                angle: _controller2.value * 2 * 3.141592653589793,
                child: child);
          },
          child: AnimatedBuilder(
              animation: _opacityAnimation2,
              builder: (context, child) {
                return Opacity(
                  opacity: _opacityAnimation2.value,
                  child: child,
                );
              },
              child: Stack(children: [
                Transform.translate(
                  offset: const Offset(41, 4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    width: widget.isLoading ? 19 : 1,
                    height: widget.isLoading ? 19 : 1,
                    decoration: const BoxDecoration(
                      color: Color(0xFF18d2d6),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                AnimatedContainer(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  width: widget.isLoading ? 58 : 19,
                  height: widget.isLoading ? 58 : 19,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF18d2d6),
                      width: 7,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ])),
        ),
        Container(
          width: 19,
          height: 19,
          decoration: const BoxDecoration(
            color: Color(0xFF18d2d6),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
