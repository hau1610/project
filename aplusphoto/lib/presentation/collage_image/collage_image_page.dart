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
  List<String> button = [
    IconConstants.buttonCollageTwo,
    IconConstants.buttonCollageThree,
    IconConstants.buttonCollageFour
  ];

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
        extendBody: true,
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
              child: ImageWidget(IconConstants.backgroundCollage),
            ),
            SizedBox(
              height: Get.height,
              width: Get.width,
              child: ListView(
                children: [
                  ImageWidget(
                    IconConstants.logoCollage,
                    height: 320,
                    fit: BoxFit.contain,
                  ),
                  Column(
                    children: List.generate(
                        button.length,
                        (index) => GestureDetector(
                            onTap: () => pushImageWidget(collageType[index]),
                            child: Container(
                                child: ImageWidget(
                              button[index],
                              height: 110,
                              fit: BoxFit.contain,
                            )))),
                  ),
                  const SizedBox(
                    height: 50,
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
