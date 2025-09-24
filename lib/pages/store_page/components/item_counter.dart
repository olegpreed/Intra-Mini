import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class ItemCounter extends StatefulWidget {
  const ItemCounter({super.key, required this.count, required this.onChanged});

  final int count;
  final ValueChanged<int> onChanged;

  @override
  State<ItemCounter> createState() => _ItemCounterState();
}

class _ItemCounterState extends State<ItemCounter> {
  late int count;

  @override
  void initState() {
    super.initState();
    count = widget.count;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 176,
      height: 70,
      // padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: context.myTheme.greySecondary,
          width: 2,
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(60),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (count > 0) {
                  setState(() {
                    count--;
                    widget.onChanged(count);
                  });
                }
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/minus.svg',
                    colorFilter: ColorFilter.mode(
                      context.myTheme.greyMain,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              width: 30,
              child: Center(
                  child: Text('$count',
                      style: Theme.of(context).textTheme.headlineMedium))),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (count >= 42) return;
                setState(() {
                  count++;
                  widget.onChanged(count);
                });
              },
              behavior: HitTestBehavior.translucent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/plus_big.svg',
                    colorFilter: ColorFilter.mode(
                      context.myTheme.greyMain,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
