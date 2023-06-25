import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_image_event.dart';
import 'color_image_state.dart';

class ColorImageBloc extends Bloc<ColorImageEvent, ColorImageState> {
  ColorImageBloc() : super(const FirstGoInColorpage(isFirst: false)) {
    on<CheckFirstGoIn>(_onCheckFirstGoIn);
  }

  Future<void> _onCheckFirstGoIn(
      CheckFirstGoIn event, Emitter<ColorImageState> emit) async {
    if (event.countOfGoIn == 1) {
      emit(const FirstGoInColorpage(isFirst: true));
    } else {
      emit(const FirstGoInColorpage(isFirst: false));
    }
  }
}
