class PictureModel {
  String stringUrl;
  double top;
  bool isSelected;
  double angle;

  /// Scale image
  double scale;
  // This is your Image link type
  bool isNetwork;
  double left;
  double topOfImage;
  double leftOfImage;
  double heightImage;
  double widthImage;

  PictureModel({
    required this.stringUrl,
    required this.top,
    required this.isSelected,
    this.angle = 0,
    required this.scale,
    required this.isNetwork,
    required this.left,
    required this.topOfImage,
    required this.leftOfImage,
    required this.heightImage,
    required this.widthImage,
  });
}
