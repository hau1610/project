import 'dart:io';
import 'dart:typed_data';

import 'package:aplusphoto/common/core/view_status.dart';
import 'package:aplusphoto/common/global_instance.dart';
import 'package:aplusphoto/presentation/imageeditingpage/blocs/image_editting_page_bloc.dart';
import 'package:aplusphoto/presentation/imageeditingpage/blocs/image_editting_page_event.dart';
import 'package:crop_image/crop_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:get/get.dart';

import '../../blocs/image_editting_page_state.dart';

class CropImagePage extends StatefulWidget {
  final String? pathImage;
  final Function(int) changeBottombar;
  final Uint8List? bytes;
  const CropImagePage({
    Key? key,
    this.pathImage,
    required this.changeBottombar,
    this.bytes,
  }) : super(key: key);

  @override
  State<CropImagePage> createState() => _CropImagePageState();
}

class _CropImagePageState extends State<CropImagePage> {
  double angle = 0;
  late CropController controller = CropController(
    aspectRatio: 1,
    defaultCrop: const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9),
  );

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return BlocListener<ImageEdittingBloc, ImageEdittingState>(
        listener: (context, state) {
          if (state.status == ViewStatus.success) {
            widget.changeBottombar(1);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: width / 5 + 22 + 30 + 20 + 10,
                    top: 60,
                    left: 20,
                    right: 20),
                child: Center(
                  child: CropImage(
                    controller: controller,
                    image: widget.bytes != null
                        ? Image.memory(widget.bytes!)
                        : Image.file(File(widget.pathImage!)),
                    alwaysMove: true,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 50.0,
              child: _buildButtons(),
            ),
          ],
        ));
  }

  Widget _buildButtons() {
    final width = Get.width;

    return Column(
      children: [
        Container(
          height: 40,
          width: width,
          margin: const EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
              color: const Color.fromRGBO(59, 58, 58, 1),
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  controller.rotation = CropRotation.up;
                  controller.aspectRatio = 1.0;
                  controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
                },
              ),
              GestureDetector(
                onTap: _aspectRatios,
                child: const Icon(
                  Icons.aspect_ratio,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              GestureDetector(
                onTap: _rotateLeft,
                child: const Icon(Icons.rotate_90_degrees_ccw_outlined,
                    size: 20, color: Colors.white),
              ),
              GestureDetector(
                onTap: _rotateRight,
                child: const Icon(Icons.rotate_90_degrees_cw_outlined,
                    size: 20, color: Colors.white),
              ),
              GestureDetector(
                onTap: _finished,
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _aspectRatios() async {
    final value = await showDialog<double>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, -1.0),
              child: const Text('free'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1.0),
              child: const Text('square'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 2.0),
              child: const Text('2:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 1 / 2),
              child: const Text('1:2'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 4.0 / 3.0),
              child: const Text('4:3'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );

    if (value != null) {
      controller.aspectRatio = value == -1 ? null : value;
      controller.crop = const Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
    }
  }

  Future<void> _rotateLeft() async => controller.rotateLeft();

  Future<void> _rotateRight() async => controller.rotateRight();

  Future<void> _finished() async {
    Image image = await controller.croppedImage();
    if (mounted) {
      context.read<ImageEdittingBloc>().add(UpdateCropImage(image: image));
      final imageCropped = await image.image.image;

      heightCropped = imageCropped.height;
      widthCropped = imageCropped.width;
    }
  }
}
