// import 'package:flutter/material.dart';
// import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

// class AnimatedLiquidLinearProgressIndicator extends StatefulWidget {
//   double aValue;
//   AnimatedLiquidLinearProgressIndicator({@required this.aValue});
//   @override
//   State<StatefulWidget> createState() =>
//       AnimatedLiquidLinearProgressIndicatorState();
// }

// class AnimatedLiquidLinearProgressIndicatorState
//     extends State<AnimatedLiquidLinearProgressIndicator>
//     with SingleTickerProviderStateMixin {
//   AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     );

//     _animationController.addListener(() => setState(() {
          
//         }));
//     _animationController.repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final percentage = widget.aValue;
//     // _animationController.value * 100;
//     return Center(
//       child: Container(
//         width: double.infinity,
//         height: 55.0,
//         padding: EdgeInsets.symmetric(horizontal: 24.0),
//         child: LiquidLinearProgressIndicator(
//           value: widget.aValue / 100,

//           //  _animationController.value,
//           backgroundColor: Color(0xFF382176).withOpacity(0.5),
//           valueColor: AlwaysStoppedAnimation(
//             Color(0xFF382176),
//           ),
//           borderRadius: 30.0,
//           center: Text(
//             "${percentage.toStringAsFixed(0)}%",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 20.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
