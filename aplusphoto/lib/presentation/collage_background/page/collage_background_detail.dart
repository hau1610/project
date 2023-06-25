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
  List<String> listBackground = [
    Picture.background1,
    Picture.background2,
    Picture.background3,
    Picture.background4,
    Picture.background5,
    Picture.background6,
    Picture.background7,
    Picture.background8,
    Picture.background9,
    Picture.background10
  ];
  double blur = 0;
  int selected = 0;

  List<bool> modeSelected = [true, false];
  ScreenshotController screenshotController = ScreenshotController();
  List<bool> isSelected =
      List.generate(10, (index) => index == 0 ? true : false);
  String imagePath = '';
  String fileName = '';
  File? file;
  bool startLoading = false;

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 18,
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
                height: 450,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Blur(
                        blur: blur,
                        colorOpacity: 0,
                        child: SizedBox(
                            height: widget.heightImage >= widget.widthImage
                                ? 450
                                : modeSelected[0]
                                    ? Get.width /
                                            widget.widthImage *
                                            widget.heightImage +
                                        50
                                    : Get.width,
                            width: widget.heightImage >= widget.widthImage
                                ? modeSelected[0]
                                    ? 450 /
                                            widget.heightImage *
                                            widget.widthImage +
                                        50
                                    : 450
                                : Get.width,
                            child: ImageWidget(
                              listBackground[selected],
                              fit: BoxFit.cover,
                            )),
                      ),
                      Container(
                        height: widget.heightImage > widget.widthImage
                            ? 450
                            : Get.width /
                                    widget.widthImage *
                                    widget.heightImage +
                                50,
                        width: widget.heightImage > widget.widthImage
                            ? 450 / widget.heightImage * widget.widthImage + 50
                            : Get.width,
                        padding: const EdgeInsets.all(50),
                        child: Image.file(
                          File(widget.pathImage),
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Positioned(
              bottom: 10,
              child: SizedBox(
                width: Get.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text('Mode',
                            style:
                                TextStyle(fontSize: 18, color: Colors.yellow)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                              2,
                              (index) => GestureDetector(
                                    onTap: () {
                                      modeSelected.fillRange(0, 2, false);
                                      modeSelected[index] = true;
                                      setState(() {});
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      width: 100,
                                      decoration: modeSelected[index]
                                          ? BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(20))
                                          : null,
                                      child: Center(
                                        child: Text(
                                            index == 0 ? 'Cover' : 'Fill',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white)),
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: Get.width,
                      height: 70,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            listBackground.length,
                            (index) => GestureDetector(
                                  onTap: () {
                                    for (int i = 0;
                                        i < isSelected.length;
                                        i++) {
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
                                        horizontal: 10,
                                        vertical: isSelected[index] ? 2 : 3),
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        border: isSelected[index]
                                            ? Border.all(
                                                width: 3, color: Colors.yellow)
                                            : null),
                                    child: ImageWidget(
                                      listBackground[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )),
                      ),
                    )
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
}
