import 'package:aplusphoto/presentation/homepage/bloc/homepage_event.dart';
import 'package:aplusphoto/presentation/homepage/bloc/homepage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  HomePageBloc() : super(HomePageStateInitial()) {
    on<GetImageEvent>(_onGetImageEvent);
    on<ChangeTabEvent>(_onChangeTabEvent);
  }

  Future<void> _onGetImageEvent(
      GetImageEvent event, Emitter<HomePageState> emit) async {
    emit(UploadImageLoading());
    final ImagePicker picker = ImagePicker();
    final images = await picker.pickImage(source: event.source);

    if (images != null) {
      emit(UploadImageSuccess(image: images.path));
    } else {
      emit(UploadImageFailure());
    }
  }

  Future<void> _onChangeTabEvent(
      ChangeTabEvent event, Emitter<HomePageState> emit) async {
    emit(ChangeTabSuccess(index: event.index));
  }
}
