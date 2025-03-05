import 'package:flutter/material.dart';

class CustomRangeSliderThumbShape extends RoundRangeSliderThumbShape {
  final double thumbRadius;
  final RangeValues rangeValues;
  final BuildContext myContext;
  final bool isThumbPressed;
  final Color borderColor;
  final Color textColor;

  CustomRangeSliderThumbShape(
      {this.thumbRadius = 10.0,
      required this.rangeValues,
      required this.myContext,
      required this.borderColor,
      required this.textColor,
      required this.isThumbPressed});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    bool? isPressed,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
  }) {
    final Canvas canvas = context.canvas;

    // Paint the thumb (circle)
    final Paint thumbPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor // Set the border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Border width

    canvas.drawCircle(center, thumbRadius, thumbPaint);
    canvas.drawCircle(center, thumbRadius, borderPaint);

    // Get the corresponding value for the thumb (start or end)
    String thumbValue;
    if (thumb == Thumb.start) {
      thumbValue =
          rangeValues.start.round().toString(); // Adjust precision as needed
    } else {
      thumbValue = rangeValues.end.round().toString();
    }

    // Draw the current value (text) inside the thumb
    final TextSpan textSpan = TextSpan(
      text: !isThumbPressed ? thumbValue : '', // Display the actual thumb value
      style: Theme.of(myContext).textTheme.bodyMedium?.copyWith(
            color: textColor,
          ),
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: textDirection,
    );

    textPainter.layout();
    final Offset textOffset = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    // Paint the value text inside the thumb
    textPainter.paint(canvas, textOffset);
  }
}

class CustomRangeSliderTrackShape extends RangeSliderTrackShape {
  final Color borderColor;

  CustomRangeSliderTrackShape({required this.borderColor});
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    Offset? offset,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight! - 2;
    final double trackTop = (parentBox.size.height - trackHeight) / 2;
    final double trackLeft = parentBox.size.width * 0.087;
    final double trackRight = parentBox.size.width * 0.913;
    return Rect.fromLTRB(
        trackLeft, trackTop, trackRight, trackTop + trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    required TextDirection textDirection,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    // Get the preferred track rectangle with adjustments
    final Rect trackRect = getPreferredRect(
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    // Define the border radius
    final BorderRadius borderRadius = BorderRadius.circular(30);

    // Adjust the trackRect to add offset to left and right by 17.5
    final adjustedTrackLeft = trackRect.left - 17.5;
    final adjustedTrackRight = trackRect.right + 17.5;

    // Create the new trackRect with adjusted size
    final adjustedTrackRect = Rect.fromLTRB(
      adjustedTrackLeft,
      trackRect.top,
      adjustedTrackRight,
      trackRect.bottom,
    );

    // Create paints for active track, inactive track, and border
    final Paint activeTrackPaint = Paint()
      ..color = sliderTheme.activeTrackColor!
      ..style = PaintingStyle.fill;

    final Paint inactiveTrackPaint = Paint()
      ..color = sliderTheme.inactiveTrackColor!
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = borderColor // Set the border color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2; // Border width

    // Create RRect with the adjusted track size and border radius
    final RRect adjustedRRect =
        RRect.fromRectAndRadius(adjustedTrackRect, borderRadius.topLeft);

    // Draw the active track with rounded corners
    final RRect activeTrack = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        startThumbCenter.dx,
        trackRect.top,
        endThumbCenter.dx,
        trackRect.bottom,
      ),
      borderRadius.topLeft,
    );
    context.canvas.drawRRect(activeTrack, activeTrackPaint);

    // Draw the inactive track with rounded corners
    final RRect inactiveTrack = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        trackRect.left,
        trackRect.top,
        startThumbCenter.dx,
        trackRect.bottom,
      ),
      borderRadius.topLeft,
    );
    context.canvas.drawRRect(inactiveTrack, inactiveTrackPaint);

    // Draw the border around the track with rounded corners
    context.canvas.drawRRect(adjustedRRect, borderPaint);
  }
}
