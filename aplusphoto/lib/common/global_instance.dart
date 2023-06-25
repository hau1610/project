import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

Widget imageFinal = Container();
Image? image;
num heightCropped = 0;
num widthCropped = 0;
int indexTab = 0;
GlobalKey globalKey = GlobalKey();
bool reset = false;
void resetData() {
  imageFinal = Container();
  heightCropped = 0;
  widthCropped = 0;
  indexTab = 0;
  image = null;
  reset = false;
}

Future<dynamic> showCapturedWidget(
    BuildContext context, Uint8List capturedImage, String path) {
  return showDialog(
      useSafeArea: false,
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => AlertDialog(
            backgroundColor: Colors.black.withOpacity(0.6),
            content: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('SUCCESS !!!',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Image.memory(capturedImage),
                  const SizedBox(height: 20),
                  const Text('Would you like to share\nthis image?',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: () {
                      try {
                        Share.shareXFiles([XFile(path)]);
                      } on PlatformException catch (e) {
                        print('Platform Exception: ${e.toString()}');
                      } catch (e) {
                        print('Exception: $e');
                      }
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Share',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
}
