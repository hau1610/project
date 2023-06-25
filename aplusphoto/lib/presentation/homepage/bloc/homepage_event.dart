import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();
  @override
  List<Object> get props => [];
}

class GetImageEvent extends HomePageEvent {
  final ImageSource source;

  const GetImageEvent({required this.source});
  @override
  List<Object> get props => [source];
}

class ChangeBottomBarEvent extends HomePageEvent {
  final int index;

  const ChangeBottomBarEvent(this.index);
  @override
  List<Object> get props => [index];
}

class ChangeTabEvent extends HomePageEvent {
  final int index;

  const ChangeTabEvent(this.index);
  @override
  List<Object> get props => [index];
}
