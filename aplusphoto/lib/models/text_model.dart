import 'package:flutter/material.dart';

class TextModel {
  String name;
  TextStyle textStyle;
  double top;
  double left;
  bool isSelected;
  TextAlign textAlign;
  double scale;
  double topOfImage;
  double leftOfImage;
  double heightImage;
  double widthImage;
  double angle;

  TextModel(
      {required this.name,
      required this.textStyle,
      required this.top,
      required this.isSelected,
      required this.textAlign,
      required this.scale,
      required this.left,
      required this.heightImage,
      required this.widthImage,
      required this.topOfImage,
      required this.leftOfImage,
      required this.angle});
}
