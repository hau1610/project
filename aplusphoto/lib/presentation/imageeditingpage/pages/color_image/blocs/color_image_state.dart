import 'package:equatable/equatable.dart';

abstract class ColorImageState extends Equatable {
  const ColorImageState();
  @override
  List<Object> get props => [];
}

class FirstGoInColorpage extends ColorImageState {
  final bool isFirst;

  const FirstGoInColorpage({required this.isFirst});
  @override
  List<Object> get props => [isFirst];
}
