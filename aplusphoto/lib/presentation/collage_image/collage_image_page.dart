import 'package:aplusphoto/presentation/collage_image/src/screens/collage_sample.dart';
import 'package:aplusphoto/presentation/collage_image/src/tranistions/fade_route_transition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_collage_widget/global.dart';
import 'package:image_collage_widget/utils/CollageType.dart';

import '../../common/images/image.dart';
import '../../common/widgets/image_widget.dart';

class CollageImagePage extends StatefulWidget {
  const CollageImagePage({super.key});

  @override
  State<CollageImagePage> createState() => _CollageImagePageState();
}

class _CollageImagePageState extends State<CollageImagePage> {
  var color = Colors.white;
  List<String> images = [Picture.collage2, Picture.collage3, Picture.collage4];
  List<String> titles = [
    'Collage Two Image',
    'Collage Three Image',
    'Collage Four Image'
  ];
  List<CollageType> collageType = [
    CollageType.VSplit,
    CollageType.ThreeVerticalLeft,
    CollageType.FourSquare
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget buildRaisedButton(CollageType collageType, String text) {
      return GestureDetector(
        onTap: () => pushImageWidget(collageType),
        child: Text(
          text,
          style: TextStyle(color: Colors.yellow, fontSize: 17),
        ),
      );
    }

    ///Create multple shapes
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: Get.height,
              width: Get.width,
              color: Color.fromARGB(255, 206, 242, 239),
            ),
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: ListView(
                children: [
                  const ImageWidget(
                    Picture.collage,
                    height: 120,
                    width: 120,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 15),
                  const Center(
                    child: Text(
                      'COLLAGE',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 35,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'I M A G E',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellowAccent,
                        ),
                        height: 8,
                        width: 8,
                      ),
                      const SizedBox(width: 15),
                      Container(
                        width: 100,
                        height: 3,
                        color: Colors.yellowAccent,
                      ),
                      const SizedBox(width: 15),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.yellowAccent,
                        ),
                        height: 8,
                        width: 8,
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Column(
                    children: List.generate(
                        images.length,
                        (index) => GestureDetector(
                              onTap: () => pushImageWidget(collageType[index]),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 10),
                                width: Get.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: index == 0
                                          ? [
                                              Color.fromARGB(
                                                  255, 232, 164, 239),
                                              Colors.pinkAccent,
                                            ]
                                          : index == 1
                                              ? [
                                                  Colors.blueAccent,
                                                  Colors.blueGrey
                                                ]
                                              : [
                                                  Colors.greenAccent,
                                                  Colors.blueGrey
                                                ],
                                    )),
                                child: Column(
                                  children: [
                                    ImageWidget(
                                      images[index],
                                      height: 50,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      titles[index],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                  )
                ],
              ),
            )
          ],
        )
        // Stack(
        //   children: [
        //     ImageWidget(
        //       Picture.collageBG,
        //       fit: BoxFit.fitHeight,
        //       height: MediaQuery.of(context).size.height,
        //     ),
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.spaceAround,
        //       children: <Widget>[
        //         buildRaisedButton(CollageType.VSplit, 'Collage Two Image'),
        //         buildRaisedButton(
        //             CollageType.ThreeVerticalLeft, 'Collage Three Image'),
        //         buildRaisedButton(CollageType.FourSquare, 'Collage Four Image'),
        //       ],
        //     ),
        //   ],
        // ),
        );
  }

  ///On click of perticular type of button show that type of widget
  pushImageWidget(CollageType type) async {
    imageGlobal = [];
    await Navigator.of(context).push(
      FadeRouteTransition(page: CollageSample(type)),
    );
  }

  RoundedRectangleBorder buttonShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0));
  }
}
