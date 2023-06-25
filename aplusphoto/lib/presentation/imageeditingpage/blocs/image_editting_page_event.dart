import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class ImageEdittingEvent extends Equatable {
  const ImageEdittingEvent();
  @override
  List<Object> get props => [];
}

class UpdateCropImage extends ImageEdittingEvent {
  final Widget image;

  const UpdateCropImage({required this.image});
  @override
  List<Object> get props => [image];
}

class CheckUpdateFilterImage extends ImageEdittingEvent {
  final bool isChanged;

  const CheckUpdateFilterImage({required this.isChanged});
  @override
  List<Object> get props => [isChanged];
}
