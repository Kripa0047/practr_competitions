import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practrCompetitions/screens/Judge/flutter_fluid_new.dart';
// import 'package:flutter_fluid_slider/flutter_fluid_slider.dart';
// import 'package:judge/screens/Judge/fluidSlider.dart';
import 'package:practrCompetitions/utils/styles.dart';
import 'package:vibration/vibration.dart';

vibrateFunc() async {
  if (await Vibration.hasVibrator()) {
    Vibration.vibrate(duration: 50);
  }
}

class JudgeSlider extends StatefulWidget {
  var saveData;
  final Function return_value;
  int index;
  final double maxValue;
  double initialValue;

  JudgeSlider({
    @required this.saveData,
    @required this.index,
    @required this.return_value,
    @required this.maxValue,
    this.initialValue = 0.0,
  });

  @override
  _JudgeSliderState createState() => _JudgeSliderState();
}

class _JudgeSliderState extends State<JudgeSlider>
    with SingleTickerProviderStateMixin {
  int convertValue(double value) {
    int val = ((value / (widget.maxValue / 5)) + 1).toInt();
    if (val > 5) {
      val = 5;
    }
    return val;
  }

  @override
  void initState() {
    super.initState();
    preValue = convertValue(widget.initialValue);
  }

  int preValue = 0;
  @override
  Widget build(BuildContext context) {
    return FluidSlider(
      thumbColor: primaryColor,
      sliderColor: Color(0xFF382176),
      value: widget.initialValue,
      min: 0.0,
      max: widget.maxValue,
      onChanged: (double newValue) {
        setState(() {
          widget.initialValue = newValue;
          widget.return_value(widget.index, newValue);
        });
      },
      onChangeEnd: (double newValue) {
        setState(() {
          widget.saveData();
          // widget.return_value(widget.index, newValue);
        });
      },
      mapValueToString: (double value) {
        int val = convertValue(value);
        if (val != preValue) {
          vibrateFunc();
          preValue = val;
        }
        // print("value here is $val");
        return val.toString();
      },
    );
  }
}
