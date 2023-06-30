import 'dart:math';

import 'package:aplusphoto/common/core/view_status.dart';
import 'package:aplusphoto/presentation/imageeditingpage/blocs/image_editting_page_bloc.dart';
import 'package:aplusphoto/presentation/imageeditingpage/blocs/image_editting_page_state.dart';
import 'package:aplusphoto/presentation/imageeditingpage/pages/color_image/color_image_page.dart';
import 'package:colorfilter_generator/addons.dart';
import 'package:colorfilter_generator/colorfilter_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_painter_v2/flutter_painter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:aplusphoto/presentation/imageeditingpage/components/blur_filter.dart';
import 'package:css_filter/css_filter.dart';

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;

import '../../../../common/global_instance.dart';
import '../../blocs/image_editting_page_event.dart';
import '../../components/list_filter.dart';
import '../stickers/controller_tab.dart';
import '../stickers/sticker_editing.dart';

class FilterImagePage extends StatefulWidget {
  const FilterImagePage({super.key, required this.pathImage});
  final String pathImage;

  @override
  State<FilterImagePage> createState() => _FilterImagePageState();
}

class _FilterImagePageState extends State<FilterImagePage> {
  ScreenshotController screenshotController = ScreenshotController();
  final _simpleFilters = listSimpleFilters;
  final _blackWhiteFilters = listBlackWhiteFilters;
  final _listCSSFilter = listCSSFilter;
  bool isChecked = false;
  bool isCSSFilter = false;
  int indexOfSimpleFilter = 0;
  int indexOfBWFilter = 0;
  int indexOfCssFilter = 0;
  int previousTab = 0;
  double brightness = 0;
  double saturation = 0;
  double hue = 0;
  double blurValue = 0;
  static const Color red = Color(0xFFFF0000);
  FocusNode textFocusNode = FocusNode();
  late PainterController controller;
  ui.Image? backgroundImage;
  Paint shapePaint = Paint()
    ..strokeWidth = 5
    ..color = Colors.red
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  bool isSticker = false;

  String imagePath = '';
  String fileName = '';
  File? file;
  bool showOriginImage = false;
  bool startLoading = false;
  void _onFilterChanged(dynamic value) {
    _filterColor.value = value;
  }

  void _onChangeSimpleFilter(int value) {
    setState(() {
      indexOfSimpleFilter = value;
    });
  }

  void _onChangeBWFilter(int value) {
    setState(() {
      indexOfBWFilter = value;
    });
  }

  void _onChangeCssFilter(int value) {
    setState(() {
      indexOfCssFilter = value;
    });
  }

  void _onChangeBrightness(double value) {
    setState(() {
      brightness = value;
    });
  }

  void _onChangeSaturation(double value) {
    setState(() {
      saturation = value;
    });
  }

  void _onChangeHue(double value) {
    setState(() {
      hue = value;
    });
  }

  Widget buildBottom() {
    return IndexedStack(
      index: indexTab,
      children: [
        Container(),
        _buildFilterSelector(),
        StickerEditingView(
          controller: controller,
          textFocusNode: textFocusNode,
        ),
        ColorImagePage(
          onChangeBrightness: _onChangeBrightness,
          onChangeHue: _onChangeHue,
          onChangeSaturation: _onChangeSaturation,
          brightness: brightness,
          saturation: saturation,
          hue: hue,
        )
      ],
    );
  }

  late ValueNotifier _filterColor;
  @override
  void initState() {
    _filterColor = ValueNotifier<dynamic>(ColorFilterGenerator(
      name: "No Filter",
      filters: [],
    ));

    controller = PainterController(
        settings: PainterSettings(
            text: TextSettings(
              focusNode: textFocusNode,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.red, fontSize: 18),
            ),
            freeStyle: const FreeStyleSettings(
              color: red,
              strokeWidth: 5,
            ),
            shape: ShapeSettings(
              paint: shapePaint,
            ),
            scale: const ScaleSettings(
              enabled: true,
              minScale: 1,
              maxScale: 5,
            )));
    // Listen to focus events of the text field
    textFocusNode.addListener(onFocus);

    // Initialize background
    initBackground();
    super.initState();
  }

  /// Fetches image from an [ImageProvider] (in this example, [NetworkImage])
  /// to use it as a background
  Future<void> initBackground() async {
    // Extension getter (.image) to get [ui.Image] from [ImageProvider]
    final image = await Image.file(File(widget.pathImage)).image.image;
    setState(() {
      backgroundImage = image;
    });
  }

  /// Updates UI when the focus changes
  void onFocus() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final width = Get.width;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  startLoading = true;
                });
                Future.delayed(const Duration(milliseconds: 200), () async {
                  imagePath = '';
                  if (Platform.isAndroid) {
                    imagePath = (await getExternalStorageDirectory())!
                        .path
                        .trim(); //from path_provide package
                  } else if (Platform.isIOS) {
                    imagePath =
                        (await getApplicationDocumentsDirectory()).path.trim();
                  }

                  Random().nextInt(15000);
                  fileName = '${Random().nextInt(15000)}.png';
                  await screenshotController.captureAndSave(
                      imagePath, //set path where screenshot will be saved
                      fileName: fileName);
                  file = await File('$imagePath/$fileName')
                      .create(recursive: true);
                  if (file != null) {
                    setState(() {
                      startLoading = false;
                    });
                    await GallerySaver.saveImage(file!.path.toString(),
                        albumName: 'AplusPhoto');
                    screenshotController
                        .capture(delay: const Duration(milliseconds: 10))
                        .then((capturedImage) async {
                      showCapturedWidget(context, capturedImage!, file!.path);
                    }).catchError((onError) {
                      print(onError);
                    });
                  }
                });
              },
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 16),
              ),
            ),
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext ctx) {
                        return AlertDialog(
                          title: const Text('Please Confirm'),
                          content:
                              const Text('Do you want to reset the picture?'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    reset = true;
                                    Navigator.pushReplacementNamed(
                                        context, '/filterpage');
                                    context.read<ImageEdittingBloc>().add(
                                        UpdateCropImage(
                                            image: Image.file(
                                                File(widget.pathImage))));
                                  });
                                },
                                child: const Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'))
                          ],
                        );
                      });
                },
                child: const Text('Reset', style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
                child: Padding(
              padding: textFocusNode.hasFocus
                  ? EdgeInsets.zero
                  : EdgeInsets.only(
                      bottom: width / 5 + 120, top: 60, left: 20, right: 20),
              child: GestureDetector(
                onLongPress: () {
                  setState(() {
                    showOriginImage = true;
                  });
                },
                onLongPressEnd: (_) {
                  setState(() {
                    showOriginImage = false;
                  });
                },
                child: Screenshot(
                    controller: screenshotController,
                    child: _buildPhotoWithFilter()),
              ),
            )),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 10.0,
            child: buildBottom(),
          ),
          indexTab == 2
              ? ControllerTab(
                  controller: controller,
                )
              : Container(),
          if (startLoading)
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const IgnorePointer(
                ignoring: true,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildPhotoWithFilter() {
    return BlocBuilder<ImageEdittingBloc, ImageEdittingState>(
        builder: (context, state) {
      final isCropped =
          state.status == ViewStatus.success && state.image is! Container;
      Widget ig = isCropped
          ? state.image!
          : Image.file(
              File(widget.pathImage),
              fit: BoxFit.cover,
            );

      return showOriginImage
          ? ig
          : ValueListenableBuilder(
              valueListenable: _filterColor,
              builder: (context, color, child) {
                final image = colorImage(
                    brightness: brightness,
                    saturation: saturation,
                    hue: hue,
                    child: isChecked
                        ? BlurFilter(
                            image: Center(
                              child: isCSSFilter
                                  ? CSSFilterPresets.apply(
                                      child: ig, value: color)
                                  : ColorFiltered(
                                      colorFilter:
                                          ColorFilter.matrix(color.matrix),
                                      child: ig,
                                    ),
                            ),
                            blurValue: blurValue,
                          )
                        : isCSSFilter
                            ? CSSFilterPresets.apply(child: ig, value: color)
                            : ColorFiltered(
                                colorFilter: ColorFilter.matrix(color.matrix),
                                child: ig,
                              ));
                return backgroundImage != null
                    ? Center(
                        child: AspectRatio(
                          aspectRatio: heightCropped != 0 && widthCropped != 0
                              ? widthCropped / heightCropped
                              : backgroundImage!.width /
                                  backgroundImage!.height,
                          child: FlutterPainter.builder(
                            controller: controller,
                            builder: (BuildContext context, Widget painter) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [image, painter],
                              );
                            },
                          ),
                        ),
                      )
                    : Container();
              });
    });
  }

  Widget _buildFilterSelector() {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.selected
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.white;
    }

    return DefaultTabController(
      length: 3,
      child: SizedBox(
        height: 10000,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            isChecked
                ? SizedBox(
                    height: 40,
                    child: Slider(
                      value: blurValue,
                      max: 5,
                      onChanged: (double value) {
                        setState(() {
                          blurValue = value;
                        });
                      },
                    ),
                  )
                : Container(),
            SizedBox(
              height: 30,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  TabBar(
                    isScrollable: true,
                    indicatorSize: TabBarIndicatorSize.tab,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.yellow,
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(fontSize: 14),
                    unselectedLabelStyle: const TextStyle(fontSize: 12),
                    onTap: (value) {
                      if (value == 0 && previousTab != value) {
                        previousTab = value;
                        isCSSFilter = false;
                        _onFilterChanged(_simpleFilters[indexOfSimpleFilter]);
                      } else if (value == 1 && previousTab != value) {
                        previousTab = value;
                        isCSSFilter = false;
                        _onFilterChanged(_blackWhiteFilters[indexOfBWFilter]);
                      } else if (previousTab != value) {
                        previousTab = value;
                        isCSSFilter = true;
                        _onFilterChanged(_listCSSFilter[indexOfCssFilter]);
                      }
                    },
                    tabs: const [
                      Tab(
                        text: 'Simple Filters',
                      ),
                      Tab(
                        text: 'Black-White Filters',
                      ),
                      Tab(
                        text: 'CSS Filters',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        value: isChecked,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        'Blur Effect',
                        style: TextStyle(
                            color: isChecked ? Colors.blue : Colors.white,
                            fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  FilterSelector(
                    onFilterChanged: _onFilterChanged,
                    filters: _simpleFilters,
                    pathImage: widget.pathImage,
                    onChangePage: _onChangeSimpleFilter,
                    index: indexOfSimpleFilter,
                  ),
                  FilterSelector(
                    onFilterChanged: _onFilterChanged,
                    filters: _blackWhiteFilters,
                    pathImage: widget.pathImage,
                    onChangePage: _onChangeBWFilter,
                    index: indexOfBWFilter,
                  ),
                  FilterSelector(
                    onFilterChanged: _onFilterChanged,
                    filters: _listCSSFilter,
                    isCSSFilter: true,
                    pathImage: widget.pathImage,
                    onChangePage: _onChangeCssFilter,
                    index: indexOfCssFilter,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget colorImage({brightness, saturation, hue, child}) {
    return ColorFiltered(
        colorFilter: ColorFilter.matrix(
          ColorFilterAddons.brightness(brightness),
        ),
        child: ColorFiltered(
            colorFilter:
                ColorFilter.matrix(ColorFilterAddons.saturation(saturation)),
            child: ColorFiltered(
              colorFilter: ColorFilter.matrix(ColorFilterAddons.hue(hue)),
              child: child,
            )));
  }
}

@immutable
class FilterSelector extends StatefulWidget {
  const FilterSelector(
      {super.key,
      required this.filters,
      required this.onFilterChanged,
      this.isCSSFilter,
      this.padding = const EdgeInsets.only(bottom: 12.0, top: 10),
      required this.pathImage,
      required this.onChangePage,
      required this.index});

  final List<dynamic> filters;
  final bool? isCSSFilter;
  final void Function(dynamic selectedColor) onFilterChanged;
  final EdgeInsets padding;
  final String pathImage;
  final Function(int) onChangePage;
  final int index;

  @override
  State<FilterSelector> createState() => _FilterSelectorState();
}

class _FilterSelectorState extends State<FilterSelector> {
  static const _filtersPerScreen = 5;
  static const _viewportFractionPerItem = 1.0 / _filtersPerScreen;

  late final PageController _controller;
  late int _page;

  int get filterCount => widget.filters.length;

  dynamic itemColor(int index) => widget.filters[index % filterCount];

  @override
  void initState() {
    super.initState();
    _page = widget.index;
    _controller = PageController(
      initialPage: _page,
      viewportFraction: _viewportFractionPerItem,
    );
    _controller.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    final page = (_controller.page ?? 0).round();
    if (page != _page) {
      _page = page;
      widget.onFilterChanged(widget.filters[page]);
      widget.onChangePage(page);
    }
  }

  void _onFilterTapped(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.ease,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      controller: _controller,
      axisDirection: AxisDirection.right,
      physics: const PageScrollPhysics(),
      viewportBuilder: (context, viewportOffset) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final itemSize = constraints.maxWidth * _viewportFractionPerItem;
            viewportOffset
              ..applyViewportDimension(constraints.maxWidth)
              ..applyContentDimensions(0.0, itemSize * (filterCount - 1));

            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _buildShadowGradient(itemSize),
                _buildCarousel(
                  viewportOffset: viewportOffset,
                  itemSize: itemSize,
                ),
                _buildSelectionRing(itemSize),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildShadowGradient(double itemSize) {
    return SizedBox(
      height: itemSize * 2 + widget.padding.vertical,
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black,
            ],
          ),
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Widget _buildCarousel({
    required ViewportOffset viewportOffset,
    required double itemSize,
  }) {
    return Container(
      height: itemSize,
      margin: widget.padding,
      child: Flow(
        delegate: CarouselFlowDelegate(
          viewportOffset: viewportOffset,
          filtersPerScreen: _filtersPerScreen,
        ),
        children: [
          for (int i = 0; i < filterCount; i++)
            FilterItem(
              onFilterSelected: () => _onFilterTapped(i),
              color: itemColor(i),
              isCSSFilter: widget.isCSSFilter,
              pathImage: widget.pathImage,
            ),
        ],
      ),
    );
  }

  Widget _buildSelectionRing(double itemSize) {
    return IgnorePointer(
      child: Padding(
        padding: widget.padding,
        child: SizedBox(
          width: itemSize,
          height: itemSize,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(width: 6.0, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CarouselFlowDelegate extends FlowDelegate {
  CarouselFlowDelegate({
    required this.viewportOffset,
    required this.filtersPerScreen,
  }) : super(repaint: viewportOffset);

  final ViewportOffset viewportOffset;
  final int filtersPerScreen;

  @override
  void paintChildren(FlowPaintingContext context) {
    final count = context.childCount;

    // All available painting width
    final size = context.size.width;

    // The distance that a single item "page" takes up from the perspective
    // of the scroll paging system. We also use this size for the width and
    // height of a single item.
    final itemExtent = size / filtersPerScreen;

    // The current scroll position expressed as an item fraction, e.g., 0.0,
    // or 1.0, or 1.3, or 2.9, etc. A value of 1.3 indicates that item at
    // index 1 is active, and the user has scrolled 30% towards the item at
    // index 2.
    final active = viewportOffset.pixels / itemExtent;

    // Index of the first item we need to paint at this moment.
    // At most, we paint 3 items to the left of the active item.
    final min = math.max(0, active.floor() - 3).toInt();

    // Index of the last item we need to paint at this moment.
    // At most, we paint 3 items to the right of the active item.
    final max = math.min(count - 1, active.ceil() + 3).toInt();

    // Generate transforms for the visible items and sort by distance.
    for (var index = min; index <= max; index++) {
      final itemXFromCenter = itemExtent * index - viewportOffset.pixels;
      final percentFromCenter = 1.0 - (itemXFromCenter / (size / 2)).abs();
      final itemScale = 0.5 + (percentFromCenter * 0.5);
      final opacity = 0.25 + (percentFromCenter * 0.75);

      final itemTransform = Matrix4.identity()
        ..translate((size - itemExtent) / 2)
        ..translate(itemXFromCenter)
        ..translate(itemExtent / 2, itemExtent / 2)
        ..multiply(Matrix4.diagonal3Values(itemScale, itemScale, 1.0))
        ..translate(-itemExtent / 2, -itemExtent / 2);

      context.paintChild(
        index,
        transform: itemTransform,
        opacity: opacity,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CarouselFlowDelegate oldDelegate) {
    return oldDelegate.viewportOffset != viewportOffset;
  }
}

@immutable
class FilterItem extends StatelessWidget {
  const FilterItem(
      {super.key,
      required this.color,
      this.onFilterSelected,
      this.isCSSFilter,
      required this.pathImage});

  final dynamic color;
  final VoidCallback? onFilterSelected;
  final bool? isCSSFilter;
  final String pathImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onFilterSelected,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
            child: isCSSFilter ?? false
                ? CSSFilterPresets.apply(
                    child: Image.file(
                      File(pathImage),
                      fit: BoxFit.cover,
                    ),
                    value: color)
                : ColorFiltered(
                    colorFilter: ColorFilter.matrix(color.matrix),
                    child: Image.file(
                      File(pathImage),
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
