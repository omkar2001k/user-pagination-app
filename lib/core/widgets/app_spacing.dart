import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static const Widget v2 = SizedBox(height: 2);
  static const Widget v4 = SizedBox(height: 4);
  static const Widget v6 = SizedBox(height: 6);
  static const Widget v8 = SizedBox(height: 8);
  static const Widget v10 = SizedBox(height: 10);
  static const Widget v12 = SizedBox(height: 12);
  static const Widget v14 = SizedBox(height: 14);
  static const Widget v16 = SizedBox(height: 16);
  static const Widget v20 = SizedBox(height: 20);
  static const Widget v24 = SizedBox(height: 24);
  static const Widget v28 = SizedBox(height: 28);
  static const Widget v32 = SizedBox(height: 32);

  static const Widget h2 = SizedBox(width: 2);
  static const Widget h4 = SizedBox(width: 4);
  static const Widget h6 = SizedBox(width: 6);
  static const Widget h8 = SizedBox(width: 8);
  static const Widget h10 = SizedBox(width: 10);
  static const Widget h12 = SizedBox(width: 12);
  static const Widget h14 = SizedBox(width: 14);
  static const Widget h16 = SizedBox(width: 16);
  static const Widget h20 = SizedBox(width: 20);
  static const Widget h24 = SizedBox(width: 24);
  static const Widget h28 = SizedBox(width: 28);
  static const Widget h32 = SizedBox(width: 32);

  static const Widget shrink = SizedBox.shrink();
  static const Widget empty = SizedBox.shrink();

  static Widget vertical(double height) => SizedBox(height: height);
  static Widget horizontal(double width) => SizedBox(width: width);
  static Widget square(double size) => SizedBox(width: size, height: size);

  static Widget line({
    double height = 24,
    double thickness = 1,
    Color? color,
    double indent = 0,
    double endIndent = 0,
  }) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

class AppLine extends StatelessWidget {
  final double height;
  final double thickness;
  final Color? color;
  final double indent;
  final double endIndent;

  const AppLine({
    super.key,
    this.height = 24,
    this.thickness = 1,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: height,
      thickness: thickness,
      color: color,
      indent: indent,
      endIndent: endIndent,
    );
  }
}

extension AppSpacingExtension on num {
  Widget get vGap => SizedBox(height: toDouble());
  Widget get hGap => SizedBox(width: toDouble());
  Widget get squareBox => SizedBox(width: toDouble(), height: toDouble());
}
