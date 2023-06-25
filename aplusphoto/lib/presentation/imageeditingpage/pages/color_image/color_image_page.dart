import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ColorImagePage extends StatefulWidget {
  Function(double) onChangeBrightness;
  Function(double) onChangeSaturation;
  Function(double) onChangeHue;
  double brightness;
  double saturation;
  double hue;
  ColorImagePage({
    super.key,
    required this.onChangeBrightness,
    required this.onChangeSaturation,
    required this.onChangeHue,
    required this.brightness,
    required this.saturation,
    required this.hue,
  });

  @override
  State<ColorImagePage> createState() => _ColorImagePageState();
}

class _ColorImagePageState extends State<ColorImagePage> {
  int indexOfTab = 0;
  final width = Get.width;
  final List icons = [
    Icons.sunny,
    Icons.brightness_6_rounded,
    Icons.deblur_rounded
  ];
  final List<String> name = ['Brightness', 'Hue', 'Saturation'];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10000,
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(59, 58, 58, 1),
              borderRadius: BorderRadius.circular(20)),
          child: Center(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(
                      icons.length,
                      (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                indexOfTab = index;
                              });
                            },
                            child: Column(
                              children: [
                                Icon(
                                  icons[index],
                                  color: indexOfTab == index
                                      ? Colors.yellow
                                      : Colors.white,
                                  size: 16,
                                ),
                                Text(
                                  name[index],
                                  style: TextStyle(
                                      color: indexOfTab == index
                                          ? Colors.yellow
                                          : Colors.white,
                                      fontSize: 12),
                                )
                              ],
                            ),
                          )),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: slider(),
        )
      ]),
    );
  }

  slider() {
    switch (indexOfTab) {
      case 0:
        return Column(
          children: [
            Slider(
              activeColor: Colors.yellow,
              value: widget.brightness,
              min: -1,
              max: 1,
              onChanged: (value) {
                setState(() {
                  widget.brightness = value;
                  widget.onChangeBrightness(value);
                });
              },
            ),
            Text(
              (widget.brightness * 100).round().toString(),
              style: const TextStyle(color: Colors.yellow),
            )
          ],
        );

      case 1:
        return Column(
          children: [
            Slider(
              activeColor: Colors.yellow,
              value: widget.hue,
              min: -0.5,
              max: 0.5,
              onChanged: (double value) {
                setState(() {
                  widget.hue = value;
                  widget.onChangeHue(value);
                });
              },
            ),
            Text(
              (widget.hue * 200).round().toString(),
              style: const TextStyle(color: Colors.yellow),
            )
          ],
        );
      case 2:
        return Column(
          children: [
            Slider(
              activeColor: Colors.yellow,
              value: widget.saturation,
              min: -1,
              max: 1,
              onChanged: (double value) {
                setState(() {
                  widget.saturation = value;
                  widget.onChangeSaturation(value);
                });
              },
            ),
            Text(
              (widget.saturation * 100).round().toString(),
              style: const TextStyle(color: Colors.yellow),
            )
          ],
        );
      default:
        Container();
    }
  }
}
