import 'dart:typed_data';

import 'package:aplusphoto/common/widgets/image_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'dart:ui' as ui;

import 'package:phosphor_flutter/phosphor_flutter.dart';

class StickerEditingView extends StatefulWidget {
  final PainterController controller;
  final FocusNode textFocusNode;
  const StickerEditingView(
      {Key? key, required this.controller, required this.textFocusNode})
      : super(key: key);

  @override
  State<StickerEditingView> createState() => _StickerEditingViewState();
}

class _StickerEditingViewState extends State<StickerEditingView> {
  List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.white,
    Colors.brown,
    Colors.purple,
    Colors.amber,
    Colors.cyan,
    Colors.grey,
    Colors.indigo,
    Colors.lime,
    Colors.red,
    Colors.teal,
    Colors.yellow,
    Colors.pink,
  ];
  List<bool> isChoose = List.generate(16, (index) => index == 0 ? true : false);
  // for (int i = 0; i < colors.length; i++) {
  //   if (i == 0) {
  //     isChoose.add(true);
  //   } else {
  //     isChoose.add(false);
  //   }
  // }
  ui.Image? backgroundImage;
  List<String> imageLinks = [];

  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  bool isSticker = false;
  Color strokeColor = Colors.red;
  Color strokeTempColor = Colors.red;
  Color textColor = Colors.red;
  Color textTempColor = Colors.red;

  @override
  void initState() {
    for (var i = 0; i < 27; i++) {
      imageLinks.add('assets/stickers/$i.png');
    }
    super.initState();
  }

  Widget buildDefault(BuildContext context) {
    return SizedBox(
      height: 10000,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, _, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Container(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                      color: Colors.white54,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.controller.freeStyleMode !=
                            FreeStyleMode.none) ...[
                          const Divider(),
                          const Text("Free Style Settings"),
                          // Control free style stroke width
                          Row(
                            children: [
                              const Expanded(
                                  flex: 1, child: Text("Stroke Width")),
                              Expanded(
                                flex: 3,
                                child: Slider.adaptive(
                                    min: 2,
                                    max: 25,
                                    value:
                                        widget.controller.freeStyleStrokeWidth,
                                    onChanged: setFreeStyleStrokeWidth),
                              ),
                            ],
                          ),
                          if (widget.controller.freeStyleMode ==
                              FreeStyleMode.draw)
                            Row(
                              children: [
                                const Text("Color"),
                                const SizedBox(width: 30),
                                IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ColorPicker(
                                                    enableAlpha: false,
                                                    labelTypes: const [],
                                                    pickerColor: strokeColor,
                                                    onColorChanged: (color) {
                                                      strokeTempColor = color;
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        strokeColor =
                                                            strokeTempColor;
                                                        widget.controller
                                                                .freeStyleColor =
                                                            strokeTempColor;
                                                      });
                                                    },
                                                    child: const Text(
                                                      'Select',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 18),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          });
                                    },
                                    icon: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: strokeColor,
                                        ))),
                              ],
                            )
                          // Row(
                          //   children: [
                          //     const Expanded(flex: 1, child: Text("Color")),
                          //     // Control free style color hue
                          //     Expanded(
                          //       flex: 3,
                          //       child: Slider.adaptive(
                          //           min: 0,
                          //           max: 359.99,
                          //           value: HSVColor.fromColor(
                          //                   widget.controller.freeStyleColor)
                          //               .hue,
                          //           activeColor:
                          //               widget.controller.freeStyleColor,
                          //           onChanged: setFreeStyleColor),
                          //     ),
                          // ),
                          // ],
                        ],
                        if (widget.textFocusNode.hasFocus) ...[
                          const Divider(),
                          const Text("Text settings"),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Text("Color"),
                              const SizedBox(width: 30),
                              IconButton(
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());
                                    await Future.delayed(
                                        const Duration(milliseconds: 100));
                                    // ignore: use_build_context_synchronously
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ColorPicker(
                                                  enableAlpha: false,
                                                  labelTypes: const [],
                                                  pickerColor: textColor,
                                                  onColorChanged: (color) {
                                                    textTempColor = color;
                                                  },
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      textColor = textTempColor;
                                                      widget.controller
                                                              .textStyle =
                                                          widget.controller
                                                              .textStyle
                                                              .copyWith(
                                                                  color:
                                                                      textTempColor);
                                                    });
                                                    addText;
                                                    addText();
                                                  },
                                                  child: const Text(
                                                    'Select',
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 18),
                                                  ),
                                                )
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                  icon: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: textColor,
                                      ))),
                            ],
                          ),
                          // Control text color hue
                          // Row(
                          //   children: [
                          //     const Expanded(flex: 1, child: Text("Color")),
                          //     Expanded(
                          //         flex: 3,
                          //         child: SizedBox(
                          //           height: 30,
                          //           child: ListView(
                          //             scrollDirection: Axis.horizontal,
                          //             children: List.generate(
                          //                 colors.length,
                          //                 (index) => GestureDetector(
                          //                       onTap: () {
                          //                         setState(() {
                          //                           for (var i = 0;
                          //                               i < isChoose.length;
                          //                               i++) {
                          //                             isChoose[i] = false;
                          //                           }
                          //                           isChoose[index] = true;
                          //                         });
                          //                         //isChoose[index] = true;

                          //                         setTextColor(colors[index]);
                          //                       },
                          //                       child: Container(
                          //                         margin: const EdgeInsets
                          //                             .symmetric(horizontal: 5),
                          //                         height: 30,
                          //                         width: 30,
                          //                         decoration: BoxDecoration(
                          //                             shape: BoxShape.circle,
                          //                             color: colors[index],
                          //                             border: isChoose[index]
                          //                                 ? Border.all(
                          //                                     width: 2,
                          //                                     color: Colors
                          //                                         .yellowAccent)
                          //                                 : null),
                          //                       ),
                          //                     )),
                          //           ),
                          //         )
                          //         // Slider.adaptive(
                          //         //     min: 0,
                          //         //     max: 359.99,
                          //         //     value: HSVColor.fromColor(
                          //         //             widget.controller.textStyle.color ??
                          //         //                 red)
                          //         //         .hue,
                          //         //     activeColor:
                          //         //         widget.controller.textStyle.color,
                          //         //     onChanged: setTextColor),
                          //         ),
                          //   ],
                          // ),

                          const SizedBox(
                            height: 10,
                          )
                        ],
                        if (widget.controller.shapeFactory != null) ...[
                          const Divider(),
                          const Text("Shape Settings"),

                          // Control text color hue
                          Row(
                            children: [
                              const Expanded(
                                  flex: 1, child: Text("Stroke Width")),
                              Expanded(
                                flex: 3,
                                child: Slider.adaptive(
                                    min: 2,
                                    max: 25,
                                    value: widget.controller.shapePaint
                                            ?.strokeWidth ??
                                        shapePaint.strokeWidth,
                                    onChanged: (value) => setShapeFactoryPaint(
                                            (widget.controller.shapePaint ??
                                                    shapePaint)
                                                .copyWith(
                                          strokeWidth: value,
                                        ))),
                              ),
                            ],
                          ),

                          // Control shape color hue
                          Row(
                            children: [
                              const Expanded(flex: 1, child: Text("Color")),
                              Expanded(
                                flex: 3,
                                child: Slider.adaptive(
                                    min: 0,
                                    max: 359.99,
                                    value: HSVColor.fromColor(
                                            (widget.controller.shapePaint ??
                                                    shapePaint)
                                                .color)
                                        .hue,
                                    activeColor:
                                        (widget.controller.shapePaint ??
                                                shapePaint)
                                            .color,
                                    onChanged: (hue) => setShapeFactoryPaint(
                                            (widget.controller.shapePaint ??
                                                    shapePaint)
                                                .copyWith(
                                          color: HSVColor.fromAHSV(1, hue, 1, 1)
                                              .toColor(),
                                        ))),
                              ),
                            ],
                          ),

                          Row(
                            children: [
                              const Expanded(
                                  flex: 1, child: Text("Fill shape")),
                              Expanded(
                                flex: 3,
                                child: Center(
                                  child: Switch(
                                      value: (widget.controller.shapePaint ??
                                                  shapePaint)
                                              .style ==
                                          PaintingStyle.fill,
                                      onChanged: (value) =>
                                          setShapeFactoryPaint(
                                              (widget.controller.shapePaint ??
                                                      shapePaint)
                                                  .copyWith(
                                            style: value
                                                ? PaintingStyle.fill
                                                : PaintingStyle.stroke,
                                          ))),
                                ),
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 40),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(59, 58, 58, 1),
                borderRadius: BorderRadius.circular(20)),
            child: ValueListenableBuilder(
              valueListenable: widget.controller,
              builder: (context, _, __) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Free-style eraser
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.eraser,
                      color:
                          widget.controller.freeStyleMode == FreeStyleMode.erase
                              ? Colors.yellow
                              : Colors.white,
                    ),
                    onPressed: toggleFreeStyleErase,
                  ),
                  // Free-style drawing
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.scribbleLoop,
                      color:
                          widget.controller.freeStyleMode == FreeStyleMode.draw
                              ? Colors.yellow
                              : Colors.white,
                    ),
                    onPressed: toggleFreeStyleDraw,
                  ),
                  // Add text
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.textT,
                      color: widget.textFocusNode.hasFocus
                          ? Colors.yellow
                          : Colors.white,
                    ),
                    onPressed: widget.textFocusNode.hasFocus ? null : addText,
                  ),
                  // Add sticker image
                  IconButton(
                    icon: Icon(
                      PhosphorIcons.sticker,
                      color: isSticker ? Colors.yellow : Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        isSticker = true;
                      });
                      addSticker();
                    },
                  ),
                  // Add shapes
                  if (widget.controller.shapeFactory == null)
                    PopupMenuButton<ShapeFactory?>(
                      tooltip: "Add shape",
                      itemBuilder: (context) => <ShapeFactory, String>{
                        LineFactory(): "Line",
                        ArrowFactory(): "Arrow",
                        DoubleArrowFactory(): "Double Arrow",
                        RectangleFactory(): "Rectangle",
                        OvalFactory(): "Oval",
                      }
                          .entries
                          .map((e) => PopupMenuItem(
                              value: e.key,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    getShapeIcon(e.key),
                                    color: Colors.black,
                                  ),
                                  Text(" ${e.value}")
                                ],
                              )))
                          .toList(),
                      onSelected: selectShape,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          getShapeIcon(widget.controller.shapeFactory),
                          color: widget.controller.shapeFactory != null
                              ? Colors.yellow
                              : Colors.white,
                        ),
                      ),
                    )
                  else
                    IconButton(
                      icon: Icon(
                        getShapeIcon(widget.controller.shapeFactory),
                        color: widget.controller.shapeFactory != null
                            ? Colors.yellow
                            : Colors.white,
                      ),
                      onPressed: () => selectShape(null),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
        // )
        ;
  }

  @override
  Widget build(BuildContext context) {
    return buildDefault(context);
  }

  static IconData getShapeIcon(ShapeFactory? shapeFactory) {
    if (shapeFactory is LineFactory) return PhosphorIcons.lineSegment;
    if (shapeFactory is ArrowFactory) return PhosphorIcons.arrowUpRight;
    if (shapeFactory is DoubleArrowFactory) {
      return PhosphorIcons.arrowsHorizontal;
    }
    if (shapeFactory is RectangleFactory) return PhosphorIcons.rectangle;
    if (shapeFactory is OvalFactory) return PhosphorIcons.circle;
    return PhosphorIcons.polygon;
  }

  void toggleFreeStyleDraw() {
    widget.controller.freeStyleMode =
        widget.controller.freeStyleMode != FreeStyleMode.draw
            ? FreeStyleMode.draw
            : FreeStyleMode.none;
  }

  void toggleFreeStyleErase() {
    widget.controller.freeStyleMode =
        widget.controller.freeStyleMode != FreeStyleMode.erase
            ? FreeStyleMode.erase
            : FreeStyleMode.none;
  }

  void addText() {
    if (widget.controller.freeStyleMode != FreeStyleMode.none) {
      widget.controller.freeStyleMode = FreeStyleMode.none;
    }
    widget.controller.addText();
  }

  void addSticker() async {
    final imageLink = await showDialog<String>(
        context: context,
        builder: (context) => SelectStickerImageDialog(
              imagesLinks: imageLinks,
            ));
    if (imageLink == null) {
      setState(() {
        isSticker = false;
      });

      return;
    }
    widget.controller.addImage(
        await Image.asset(imageLink).image.image, const Size(100, 100));

    isSticker = false;
  }

  void setFreeStyleStrokeWidth(double value) {
    widget.controller.freeStyleStrokeWidth = value;
  }

  void setFreeStyleColor(double hue) {
    widget.controller.freeStyleColor =
        HSVColor.fromAHSV(1, hue, 1, 1).toColor();
  }

  void setTextFontSize(double size) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      widget.controller.textSettings = widget.controller.textSettings.copyWith(
          textStyle: widget.controller.textSettings.textStyle
              .copyWith(fontSize: size));
    });
  }

  void setShapeFactoryPaint(Paint paint) {
    // Set state is just to update the current UI, the [FlutterPainter] UI updates without it
    setState(() {
      widget.controller.shapePaint = paint;
    });
  }

  void setTextColor(Color hue) {
    widget.controller.textStyle =
        widget.controller.textStyle.copyWith(color: hue);
  }

  void selectShape(ShapeFactory? factory) {
    widget.controller.shapeFactory = factory;
  }

  // void renderAndDisplayImage() {
  //   if (backgroundImage == null) return;
  //   final backgroundImageSize =
  //       Size(backgroundImage!.width!, backgroundImage!.height!);

  //   // Render the image
  //   // Returns a [ui.Image] object, convert to to byte data and then to Uint8List
  //   final imageFuture = controller
  //       .renderImage(backgroundImageSize)
  //       .then<Uint8List?>((ui.Image image) => image.pngBytes);

  //   // From here, you can write the PNG image data a file or do whatever you want with it
  //   // For example:
  //   // ```dart
  //   // final file = File('${(await getTemporaryDirectory()).path}/img.png');
  //   // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   // ```
  //   // I am going to display it using Image.memory

  //   // Show a dialog with the image
  //   showDialog(
  //       context: context,
  //       builder: (context) => RenderedImageDialog(imageFuture: imageFuture));
  // }
}

class RenderedImageDialog extends StatelessWidget {
  final Future<Uint8List?> imageFuture;

  const RenderedImageDialog({Key? key, required this.imageFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Rendered Image"),
      content: FutureBuilder<Uint8List?>(
        future: imageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const SizedBox(
              height: 50,
              child: Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox();
          }
          return InteractiveViewer(
              maxScale: 10, child: Image.memory(snapshot.data!));
        },
      ),
    );
  }
}

class SelectStickerImageDialog extends StatelessWidget {
  final List<String> imagesLinks;

  const SelectStickerImageDialog({Key? key, this.imagesLinks = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select sticker"),
      content: imagesLinks.isEmpty
          ? const Text("No images")
          : FractionallySizedBox(
              heightFactor: 0.5,
              child: SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (final imageLink in imagesLinks)
                      InkWell(
                        onTap: () => Navigator.pop(context, imageLink),
                        child: FractionallySizedBox(
                          widthFactor: 1 / 4,
                          child: ImageWidget(imageLink),
                        ),
                      ),
                  ],
                ),
              ),
            ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );
  }
}
