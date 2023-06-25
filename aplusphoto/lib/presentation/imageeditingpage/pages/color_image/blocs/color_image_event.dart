import 'package:equatable/equatable.dart';

abstract class ColorImageEvent extends Equatable {
  const ColorImageEvent();
  @override
  List<Object> get props => [];
}

class CheckFirstGoIn extends ColorImageEvent {
  final int countOfGoIn;

  const CheckFirstGoIn({required this.countOfGoIn});
  @override
  List<Object> get props => [countOfGoIn];
}
