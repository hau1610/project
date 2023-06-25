import 'package:equatable/equatable.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();
  @override
  List<Object> get props => [];
}

class HomePageStateInitial extends HomePageState {}

class UploadImageLoading extends HomePageState {}

class UploadImageSuccess extends HomePageState {
  final String image;
  const UploadImageSuccess({required this.image});
  @override
  List<Object> get props => [image];
}

class ChangeTabSuccess extends HomePageState {
  final int index;
  const ChangeTabSuccess({required this.index});
  @override
  List<Object> get props => [index];
}

class UploadImageFailure extends HomePageState {}
