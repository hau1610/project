library image_collage_widget;

import 'package:aplusphoto/common/images/image.dart';
import 'package:aplusphoto/common/widgets/image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_collage_widget/image_collage_widget.dart';
import 'package:image_collage_widget/model/images.dart';
import 'package:image_collage_widget/utils/CollageType.dart';

/// A CollageWidget.
class CollageSample extends StatefulWidget {
  final CollageType collageType;

  const CollageSample(this.collageType, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _CollageSample();
  }
}

class _CollageSample extends State<CollageSample> {
  getPage() {
    if (widget.collageType == CollageType.VSplit) {
      return 2;
    } else if (widget.collageType == CollageType.FourSquare) {
      return 5;
    } else if (widget.collageType == CollageType.ThreeVerticalLeft) {
      return 4;
    }
  }

  List<Images> listImage = [];
  int index = 0;
  bool startLoading = false;
  List<CollageType> collageTwoImage = [CollageType.VSplit, CollageType.HSplit];

  List<CollageType> collageThreeImage = [
    CollageType.ThreeVerticalLeft,
    CollageType.ThreeVerticalRight,
    CollageType.ThreeHorizontalTop,
    CollageType.ThreeHorizontalBottom
  ];
  List<CollageType> collageFourImage = [
    CollageType.FourSquare,
    CollageType.FourLeftBig,
    CollageType.FourRightBig,
    CollageType.FourTopBig,
    CollageType.FourBottomBig
  ];
  List<String> listTwoImageFrame = [Picture.collage2, Picture.collage2a];
  List<String> listThreeImageFrame = [
    Picture.collage3,
    Picture.collage3a,
    Picture.collage3b,
    Picture.collage3c
  ];
  List<String> listFourImageFrame = [
    Picture.collage4,
    Picture.collage4a,
    Picture.collage4b,
    Picture.collage4c,
    Picture.collage4d
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: widget.collageType == CollageType.VSplit
              ? Colors.pink
              : widget.collageType == CollageType.ThreeVerticalLeft
                  ? Colors.blue
                  : Colors.green,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "COLLAGE IMAGE",
          ),
        ),
        body: Stack(
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: widget.collageType == CollageType.VSplit
                    ? [
                        Colors.pinkAccent,
                        Colors.deepPurpleAccent,
                      ]
                    : widget.collageType == CollageType.ThreeVerticalLeft
                        ? [Colors.blueAccent, Colors.blueGrey]
                        : [Colors.greenAccent, Colors.blueGrey],
              )),
            ),
            DefaultTabController(
              length: getPage(),
              child: Stack(
                children: [
                  // if(widget.collageType==CollageType.VSplit)

                  // else if(widget.collageType==CollageType.ThreeVerticalLeft)
                  // Container()
                  // else if(widget.collageType==CollageType.FourSquare)
                  SizedBox(
                    width: Get.width,
                    height: Get.height,
                  ),
                  Positioned(
                    top: 20,
                    child: SizedBox(
                      width: Get.width,
                      height: 480,
                      child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(getPage(), (index) {
                            Widget buildCollageImage = Container();
                            if (widget.collageType == CollageType.VSplit) {
                              buildCollageImage = ImageCollageWidget(
                                collageType: collageTwoImage[index],
                                withImage: true,
                              );
                            } else if (widget.collageType ==
                                CollageType.ThreeVerticalLeft) {
                              buildCollageImage = ImageCollageWidget(
                                collageType: collageThreeImage[index],
                                withImage: true,
                              );
                            } else {
                              buildCollageImage = ImageCollageWidget(
                                collageType: collageFourImage[index],
                                withImage: true,
                              );
                            }
                            return buildCollageImage;
                          })),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    child: SizedBox(
                      height: 80,
                      width: Get.width,
                      child: TabBar(
                          isScrollable: true,
                          indicator: BoxDecoration(
                            border: Border.all(color: Colors.yellow, width: 4),
                          ),
                          indicatorWeight: 0,
                          padding: EdgeInsets.zero,
                          indicatorPadding: EdgeInsets.zero,
                          indicatorColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.label,
                          onTap: (index) {},
                          tabs: List.generate(
                              getPage(),
                              (index) => Container(
                                    margin: const EdgeInsets.all(4),
                                    width: 80,
                                    child: ImageWidget(
                                      widget.collageType == CollageType.VSplit
                                          ? listTwoImageFrame[index]
                                          : widget.collageType ==
                                                  CollageType.ThreeVerticalLeft
                                              ? listThreeImageFrame[index]
                                              : listFourImageFrame[index],
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ))),
                    ),
                  )
                ],
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
        ));
  }
}
