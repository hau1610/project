import 'dart:io';
import 'dart:math';

import 'package:aplusphoto/common/images/image.dart';
import 'package:aplusphoto/common/widgets/image_widget.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../common/global_instance.dart';

class CollageBackgroundDetail extends StatefulWidget {
  final String pathImage;
  final int widthImage;
  final int heightImage;

  const CollageBackgroundDetail(
      {super.key,
      required this.pathImage,
      required this.heightImage,
      required this.widthImage});

  @override
  State<CollageBackgroundDetail> createState() =>
      _CollageBackgroundDetailState();
}

class _CollageBackgroundDetailState extends State<CollageBackgroundDetail> {
  List<String> listBackgroundMix = [
    Picture.backgroundMix1,
    Picture.backgroundMix2,
    Picture.backgroundMix3,
    Picture.backgroundMix4,
    Picture.backgroundMix5,
    Picture.backgroundMix6,
  ];
  List<String> listBackgroundBlue = [
    Picture.backgroundBlue1,
    Picture.backgroundBlue2,
    Picture.backgroundBlue3,
    Picture.backgroundBlue4,
    Picture.backgroundBlue5,
    Picture.backgroundBlue6,
  ];

  List<String> listBackgroundGreen = [
    Picture.backgroundGreen1,
    Picture.backgroundGreen2,
    Picture.backgroundGreen3,
    Picture.backgroundGreen4,
    Picture.backgroundGreen5,
    Picture.backgroundGreen6,
  ];
  List<String> listBackgroundRed = [
    Picture.backgroundRed1,
    Picture.backgroundRed2,
    Picture.backgroundRed3,
    Picture.backgroundRed4,
    Picture.backgroundRed5,
    Picture.backgroundRed6,
  ];
  List<String> listBackgroundPink = [
    Picture.backgroundPink1,
    Picture.backgroundPink2,
    Picture.backgroundPink3,
    Picture.backgroundPink4,
    Picture.backgroundPink5,
    Picture.backgroundPink6,
  ];
  List<String> listBackgroundOrange = [
    Picture.backgroundOrange1,
    Picture.backgroundOrange2,
    Picture.backgroundOrange3,
    Picture.backgroundOrange4,
    Picture.backgroundOrange5,
    Picture.backgroundOrange6,
  ];
  List<String> nameBackground = [
    'Mix',
    'Green',
    'Blue',
    'Red',
    'Pink',
    'Orange'
  ];
  List listBackground = [
    Picture.backgroundMix1,
    Picture.backgroundMix2,
    Picture.backgroundMix3,
    Picture.backgroundMix4,
    Picture.backgroundMix5,
    Picture.backgroundMix6,
  ];

  double blur = 0;
  int selected = 0;
  int index = 0;
  List<bool> modeSelected = [true, false, false];
  ScreenshotController screenshotController = ScreenshotController();
  List<bool> isSelected =
      List.generate(6, (index) => index == 0 ? true : false);
  String imagePath = '';
  String fileName = '';
  File? file;
  bool startLoading = false;
  double angle = 0.0;

  @override
  Widget build(BuildContext context) {
    final bool checkRatio = widget.heightImage / widget.widthImage >= 1.3 ||
            widget.widthImage / widget.heightImage >= 1.3
        ? true
        : false;
    print(widget.widthImage / widget.heightImage);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  setState(() {
                    startLoading = true;
                  });
                  Future.delayed(const Duration(milliseconds: 200), () async {
                    imagePath = '';
                    if (Platform.isAndroid) {
                      imagePath = (await getExternalStorageDirectory())!
                          .path
                          .trim(); //from path_provide package
                    } else if (Platform.isIOS) {
                      imagePath = (await getApplicationDocumentsDirectory())
                          .path
                          .trim();
                    }

                    Random().nextInt(15000);
                    fileName = '${Random().nextInt(15000)}.png';
                    await screenshotController.captureAndSave(
                        imagePath, //set path where screenshot will be saved
                        fileName: fileName);
                    file = await File('$imagePath/$fileName')
                        .create(recursive: true);
                    if (file != null) {
                      setState(() {
                        startLoading = false;
                      });
                      await GallerySaver.saveImage(file!.path.toString(),
                          albumName: 'AplusPhoto');
                      screenshotController
                          .capture(delay: const Duration(milliseconds: 10))
                          .then((capturedImage) async {
                        showCapturedWidget(context, capturedImage!, file!.path);
                      }).catchError((onError) {
                        print(onError);
                      });
                    }
                  });
                },
                icon: const Text(
                  'Save',
                  style: TextStyle(
                      color: Colors.yellow,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                )),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Stack(
          children: [
            Screenshot(
              controller: screenshotController,
              child: SizedBox(
                height: Get.width,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Blur(
                        blur: blur,
                        colorOpacity: 0,
                        child: SizedBox(
                            height: widget.heightImage >= widget.widthImage
                                ? modeSelected[1]
                                    ? Get.width - 100
                                    : Get.width
                                : modeSelected[0]
                                    ? checkRatio
                                        ? Get.width /
                                            widget.widthImage *
                                            widget.heightImage
                                        : Get.width /
                                                widget.widthImage *
                                                widget.heightImage -
                                            100
                                    : Get.width,
                            width: widget.heightImage >= widget.widthImage
                                ? modeSelected[0]
                                    ? checkRatio
                                        ? Get.width /
                                            widget.heightImage *
                                            widget.widthImage
                                        : Get.width /
                                                widget.heightImage *
                                                widget.widthImage -
                                            100
                                    : Get.width
                                : modeSelected[1]
                                    ? Get.width - 100
                                    : Get.width,
                            child: ImageWidget(
                              listBackground[selected],
                              fit: BoxFit.fill,
                            )),
                      ),
                      InteractiveViewer(
                        boundaryMargin: EdgeInsets.all(Get.width / 2),
                        minScale: 0.85,
                        maxScale: 2,
                        child: Container(
                          height: widget.heightImage >= widget.widthImage
                              ? modeSelected[1]
                                  ? Get.width - 100
                                  : Get.width
                              : modeSelected[0]
                                  ? checkRatio
                                      ? Get.width /
                                          widget.widthImage *
                                          widget.heightImage
                                      : Get.width /
                                              widget.widthImage *
                                              widget.heightImage -
                                          100
                                  : Get.width,
                          width: widget.heightImage >= widget.widthImage
                              ? modeSelected[0]
                                  ? checkRatio
                                      ? Get.width /
                                          widget.heightImage *
                                          widget.widthImage
                                      : Get.width /
                                              widget.heightImage *
                                              widget.widthImage -
                                          100
                                  : Get.width
                              : modeSelected[1]
                                  ? Get.width - 100
                                  : Get.width,
                          padding: const EdgeInsets.all(20),
                          child: Image.file(
                            File(widget.pathImage),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Positioned(
              bottom: 5,
              child: SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 30),
                          child: Text('Blur',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.yellow)),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Slider(
                                thumbColor: Colors.yellow,
                                activeColor: Colors.yellow,
                                max: 4,
                                value: blur,
                                onChanged: (value) {
                                  setState(() {
                                    blur = value;
                                  });
                                }),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text('Mode',
                          style: TextStyle(fontSize: 18, color: Colors.yellow)),
                    ),
                    SizedBox(
                      width: Get.width,
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            3,
                            (index) => GestureDetector(
                                  onTap: () {
                                    modeSelected.fillRange(0, 3, false);
                                    modeSelected[index] = true;
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    width: 150,
                                    decoration: modeSelected[index]
                                        ? BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius:
                                                BorderRadius.circular(20))
                                        : null,
                                    child: Center(
                                      child: Text(
                                          index == 0
                                              ? 'Vertical'
                                              : index == 1
                                                  ? 'Horizontal'
                                                  : 'Square',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.white)),
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: Get.width,
                      height: 20,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            6,
                            (index) => GestureDetector(
                                  onTap: () {
                                    isSelected = List.generate(6,
                                        (index) => index == 0 ? true : false);
                                    this.index = index;
                                    selected = 0;
                                    switch (index) {
                                      case 0:
                                        listBackground = listBackgroundMix;
                                        break;
                                      case 1:
                                        listBackground = listBackgroundGreen;
                                        break;
                                      case 2:
                                        listBackground = listBackgroundBlue;
                                        break;
                                      case 3:
                                        listBackground = listBackgroundRed;
                                        break;
                                      case 4:
                                        listBackground = listBackgroundPink;
                                        break;

                                      case 5:
                                        listBackground = listBackgroundOrange;
                                        break;
                                    }
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Text(
                                      nameBackground[index],
                                      style: TextStyle(
                                          color: this.index == index
                                              ? Colors.yellow
                                              : Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                )),
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildListBackGround()
                  ],
                ),
              ),
            ),
            if (startLoading)
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const IgnorePointer(
                  ignoring: true,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget buildListBackGround() {
    return SizedBox(
      width: Get.width,
      height: 70,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
            listBackground.length,
            (index) => GestureDetector(
                  onTap: () {
                    for (int i = 0; i < isSelected.length; i++) {
                      if (i == index) {
                        isSelected[i] = true;
                      } else {
                        isSelected[i] = false;
                      }
                    }
                    selected = index;
                    setState(() {});
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 10, vertical: isSelected[index] ? 2 : 3),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        border: isSelected[index]
                            ? Border.all(width: 3, color: Colors.yellow)
                            : null),
                    child: ImageWidget(
                      listBackground[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
      ),
    );
  }
}
