import 'package:aplusphoto/common/core/view_status.dart';
import 'package:aplusphoto/presentation/imageeditingpage/blocs/image_editting_page_event.dart';
import 'package:aplusphoto/presentation/imageeditingpage/blocs/image_editting_page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageEdittingBloc extends Bloc<ImageEdittingEvent, ImageEdittingState> {
  ImageEdittingBloc() : super(const ImageEdittingState()) {
    on<UpdateCropImage>(_onUpdateCropImage);
    on<CheckUpdateFilterImage>(_onCheckUpdateFilterImage);
  }

  Future<void> _onUpdateCropImage(
      UpdateCropImage event, Emitter<ImageEdittingState> emit) async {
    if (event.image is Container) {
      emit(state.copyWith(image: Container(), status: ViewStatus.error));
    }
    emit(state.copyWith(image: event.image, status: ViewStatus.success));
  }

  Future<void> _onCheckUpdateFilterImage(
      CheckUpdateFilterImage event, Emitter<ImageEdittingState> emit) async {
    emit(state.copyWith(isChangeFilter: event.isChanged));
  }
}
