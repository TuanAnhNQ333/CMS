import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  const RatingBar({super.key, required this.onRatingChanged, required this.initialRating,});

  final Function(double rating) onRatingChanged;
  final double initialRating;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  var sliderValue = 0.0;

  @override
  void initState() {
    super.initState();
    sliderValue = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).primaryColor,
            inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.2),
            thumbColor: Colors.orange,
            trackHeight: 10.0,
            showValueIndicator: ShowValueIndicator.onlyForDiscrete,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.orange,
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white,
            ),
          ),
          child: Slider(
            value: sliderValue,
            min: 0,
            max: 5,
            divisions: 5,
            label: sliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                sliderValue = value;
                widget.onRatingChanged(value);
              });
            },
          ),
        ),
      ],
    );
  }
}

class CustomThumbShape extends RoundSliderThumbShape {
  final TextPainter textPainter = TextPainter();

  @override
  void paint(
      PaintingContext context,
      Offset center, {
        required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow,
      }) {
    super.paint(
      context,
      center,
      activationAnimation: activationAnimation,
      enableAnimation: enableAnimation,
      isDiscrete: isDiscrete,
      labelPainter: labelPainter,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      textDirection: textDirection,
      value: value,
      textScaleFactor: textScaleFactor,
      sizeWithOverflow: sizeWithOverflow,
    );

    textPainter.text = TextSpan(
      text: '${value.round()}',
      style: sliderTheme.valueIndicatorTextStyle,
    );

    textPainter.textDirection = TextDirection.rtl; // Change text direction here
    textPainter.textScaleFactor = textScaleFactor;
    textPainter.layout();

    final Offset textOffset = Offset(
      center.dx - (textPainter.width / 2),
      center.dy - (textPainter.height / 2),
    );

    textPainter.paint(context.canvas, textOffset);
  }
}
