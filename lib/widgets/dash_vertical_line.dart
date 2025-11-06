import 'package:flutter/material.dart';

class DashVerticalLine extends StatelessWidget {
  final double dashheight;
  final double dashWidth;
  final Color color;
  final double dashGap;
  const DashVerticalLine(
      {super.key,
     this.dashheight = 4,
      this.dashWidth =1 ,
       this.color = Colors.black26,

       this.dashGap =4});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount =
            (constraints.maxHeight / (dashheight + dashGap)).floor();
        return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(dashCount, (_) {
              return Padding(padding: EdgeInsets.only(bottom: dashGap),
              child: SizedBox(
                height: dashheight,
                width: dashWidth,
                child: DecoratedBox(decoration: BoxDecoration(color: color),
                ),
              ),
              );

            }));
      },
    );
  }
}
