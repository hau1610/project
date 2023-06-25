import 'package:flutter/material.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ControllerTab extends StatelessWidget {
  final PainterController controller;

  const ControllerTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        right: 0,
        child: Row(
          children: [
            // Delete the selected drawable
            IconButton(
              icon: const Icon(
                PhosphorIcons.trash,
                color: Colors.white,
              ),
              onPressed: removeSelectedDrawable,
            ),
            // Delete the selected drawable
            IconButton(
                icon: const Icon(
                  Icons.flip,
                  color: Colors.white,
                ),
                onPressed: flipSelectedImageDrawable),
            // Redo action
            IconButton(
              icon: const Icon(
                PhosphorIcons.arrowClockwise,
                color: Colors.white,
              ),
              onPressed: redo,
            ),
            // Undo action
            IconButton(
              icon: const Icon(
                PhosphorIcons.arrowCounterClockwise,
                color: Colors.white,
              ),
              onPressed: undo,
            ),
          ],
        ));
  }

  void undo() {
    controller.undo();
  }

  void redo() {
    controller.redo();
  }

  void removeSelectedDrawable() {
    final selectedDrawable = controller.selectedObjectDrawable;
    if (selectedDrawable != null) {
      controller.removeDrawable(selectedDrawable);
    }
  }

  void flipSelectedImageDrawable() {
    final imageDrawable = controller.selectedObjectDrawable;
    if (imageDrawable is! ImageDrawable) return;

    controller.replaceDrawable(
        imageDrawable, imageDrawable.copyWith(flipped: !imageDrawable.flipped));
  }
}
