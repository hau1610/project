import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class BlurFilter extends StatelessWidget {
  final Widget image;
  final double blurValue;
  const BlurFilter({Key? key, required this.image, required this.blurValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: image.blurred(blur: blurValue, colorOpacity: 0),
        ),
      ],
    );
  }
}
