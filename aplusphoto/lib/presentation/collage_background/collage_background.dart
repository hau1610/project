import 'dart:io';

import 'package:aplusphoto/presentation/collage_background/page/collage_background_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/images/image.dart';
import '../../common/widgets/image_widget.dart';

class CollageBackground extends StatefulWidget {
  const CollageBackground({super.key});

  @override
  State<CollageBackground> createState() => _CollageBackgroundState();
}

class _CollageBackgroundState extends State<CollageBackground> {
  @override
  Widget build(BuildContext context) {
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
              color: Colors.blueAccent,
            ),
            Positioned(
              top: -100,
              right: -150,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                height: 300,
                width: 300,
              ),
            ),
            Positioned(
              bottom: -100,
              left: -150,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.yellow,
                ),
                height: 300,
                width: 300,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const ImageWidget(
                  Picture.addBackground,
                  height: 120,
                  width: 120,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 15),
                const Center(
                  child: Text(
                    'BACKGROUND',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const Center(
                  child: Text(
                    'I M A G E',
                    style: TextStyle(
                        color: Colors.yellow,
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
                        color: Colors.white,
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
                        color: Colors.white,
                      ),
                      height: 8,
                      width: 8,
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                GestureDetector(
                  onTap: () {
                    _getFromGallery();
                  },
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 70),
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Colors.lightGreen, Colors.green])),
                      child: const Center(
                        child: Text(
                          'Choose Image',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      )),
                )
              ],
            ),
          ],
        ));
  }

  _getFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final images = await picker.pickImage(source: ImageSource.gallery);

    if (images != null) {
      final imageCropped = File(images.path);
      var decodedImage =
          await decodeImageFromList(imageCropped.readAsBytesSync());
      print(decodedImage.width);
      print(decodedImage.height);
      Get.to(() => CollageBackgroundDetail(
            pathImage: images.path,
            heightImage: decodedImage.height,
            widthImage: decodedImage.width,
          ));
    }
  }
}
