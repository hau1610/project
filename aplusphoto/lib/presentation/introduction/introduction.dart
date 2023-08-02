import 'package:aplusphoto/common/images/image.dart';
import 'package:aplusphoto/common/widgets/image_widget.dart';
import 'package:aplusphoto/presentation/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Introduction extends StatelessWidget {
  const Introduction({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          ImageWidget(Picture.onboarding, height: height, width: width),
          Positioned(
            bottom: height / 15,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  width: width - 100,
                  child: const Text(
                    'Edit Photos Like a Pro in Just One Click',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        height: 1.5,
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(height: 22),
                GestureDetector(
                  onTap: () {
                    Get.to(() => (const HomePage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 12),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(101, 115, 237, 1),
                              Color.fromRGBO(99, 117, 237, 1),
                              Color.fromRGBO(84, 135, 236, 1),
                              Color.fromRGBO(67, 155, 234, 1),
                              Color.fromRGBO(51, 174, 233, 1),
                              Color.fromRGBO(20, 210, 230, 1),
                            ])),
                    child: const Text("LET'S START",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
