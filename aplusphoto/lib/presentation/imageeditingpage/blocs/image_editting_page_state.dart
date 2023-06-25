import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../common/core/view_status.dart';

class ImageEdittingState extends Equatable {
  final ViewStatus status;
  final Widget? image;
  final bool isChangeFilter;

  const ImageEdittingState(
      {this.status = ViewStatus.initial,
      this.image,
      this.isChangeFilter = false});
  ImageEdittingState copyWith(
      {ViewStatus? status, Widget? image, bool? isChangeFilter}) {
    return ImageEdittingState(
        status: status ?? this.status,
        image: image ?? this.image,
        isChangeFilter: isChangeFilter ?? this.isChangeFilter);
  }

  @override
  List<Object?> get props => [status, image];
}
