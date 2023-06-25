import 'package:aplusphoto/common/widgets/skeleton.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class ImageWidget extends StatefulWidget {
  static ErrorWidgetBuilder errorWidgetBuilder = () => null;

  final String source;
  final BoxFit fit;
  final double? width;
  final double? height;
  final bool usePlaceHolder;
  final Color? color;
  final double? borderRadius;
  final String? package;
  final int? cacheWidth;
  final int? cacheHeight;
  final double aspectRatio;
  final bool useFadeInAnimation;
  final Widget? errorWidget;

  const ImageWidget(
    this.source, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.usePlaceHolder = true,
    this.color,
    this.borderRadius,
    this.package,
    this.cacheWidth,
    this.cacheHeight,
    this.aspectRatio = 2.0,
    this.useFadeInAnimation = true,
    this.errorWidget,
  }) : super(key: key);

  const ImageWidget.avatar(
    this.source, {
    Key? key,
    this.fit = BoxFit.cover,
    this.width = 40,
    this.height = 40,
    this.usePlaceHolder = true,
    this.color,
    this.borderRadius = 10,
    this.package,
    this.cacheWidth,
    this.cacheHeight,
    this.aspectRatio = 2.0,
    this.useFadeInAnimation = true,
    this.errorWidget,
  }) : super(key: key);

  Widget copyWith({Color? color, double? width, double? height}) {
    return ImageWidget(
      source,
      key: key,
      fit: fit,
      width: width ?? width,
      height: height ?? height,
      usePlaceHolder: usePlaceHolder,
      color: color ?? color,
      borderRadius: borderRadius,
    );
  }

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (widget.source.isEmpty) {
      body = const Placeholder();
    } else if (widget.source.contains('.svg')) {
      body = widget.source.contains('http')
          ? SvgPicture.network(
              widget.source,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
            )
          : SvgPicture.asset(
              widget.source,
              fit: widget.fit,
              width: widget.width,
              height: widget.height,
            );
    } else if (widget.source.contains('http')) {
      body = ExtendedImage.network(
        widget.source,
        cache: true,
        fit: widget.fit,
        color: widget.color,
        loadStateChanged: loadStateChanged,
        cacheWidth: widget.cacheWidth,
        cacheHeight: widget.cacheHeight,
      );
    } else if (widget.source.contains('.json')) {
      return Lottie.asset(
        widget.source,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
      );
    } else {
      body = Image.asset(
        widget.source,
        fit: widget.fit,
        color: widget.color,
        width: widget.width,
        height: widget.height,
      );
    }
    if (widget.borderRadius != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius!),
        child: body,
      );
    }

    return body;
  }

  Widget? loadStateChanged(ExtendedImageState state) {
    late Widget image;
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        _controller.reset();

        if (widget.width != null) {
          return SizedBox(
              width: widget.width,
              height: widget.height,
              child: const Skeleton());
        }
        return LayoutBuilder(builder: (context, contraint) {
          return AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: const Skeleton(),
          );
        });

      case LoadState.completed:
        _controller.forward();

        if (widget.useFadeInAnimation) {
          image = FadeTransition(
              opacity: _controller,
              child: ExtendedRawImage(
                image: state.extendedImageInfo?.image,
                width: widget.width,
                height: widget.height,
                fit: widget.fit,
              ));
        } else {
          image = ExtendedRawImage(
            image: state.extendedImageInfo?.image,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
        }
        break;
      case LoadState.failed:
        _controller.reset();
        if (widget.errorWidget != null) {
          image = widget.errorWidget!;
        } else {
          final errorWidget = ImageWidget.errorWidgetBuilder();
          if (errorWidget != null) {
            image = SizedBox(
              width: widget.width,
              height: widget.height,
              child: errorWidget,
            );
          } else {
            image = Container(
              width: widget.width,
              height: widget.height,
              color: Colors.grey,
            );
          }
        }
        break;
    }
    return image;
  }
}

typedef ErrorWidgetBuilder = Widget? Function();
