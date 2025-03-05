import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';

class SwitchTextButton extends StatefulWidget {
  const SwitchTextButton({
    super.key,
    required this.onPressed,
    required this.leftText,
    required this.rightText,
  });

  final Function(int) onPressed;
  final String leftText;
  final String rightText;

  @override
  State<SwitchTextButton> createState() => _SwitchTextButtonState();
}

class _SwitchTextButtonState extends State<SwitchTextButton> {
  int _selectedIndex = 0;

  Alignment _getAlignment() {
    return _selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight;
  }

  Widget _buildOption({required String text, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (_selectedIndex != index) {
            widget.onPressed(index);
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        child: Container(
          alignment: Alignment.center,
          height: 40,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : context.myTheme.greyMain,
                    ) ??
                const TextStyle(),
            child: Text(text),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double cellWidth = (screenWidth - 50) / 2;
    double cellHeight = 40;

    return Container(
      padding: const EdgeInsets.all(5),
      width: 400,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 150),
            alignment: _getAlignment(),
            child: Container(
              height: cellHeight,
              width: cellWidth,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
          Row(
            children: [
              _buildOption(text: widget.leftText, index: 0), // Left option
              _buildOption(text: widget.rightText, index: 1), // Right option
            ],
          ),
        ],
      ),
    );
  }
}
