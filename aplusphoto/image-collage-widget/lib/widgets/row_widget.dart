import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_collage_widget/global.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../blocs/collage_event.dart';
import '../blocs/collage_bloc.dart';
import '../blocs/collage_state.dart';
import '../model/images.dart';
import '../utils/CollageType.dart';
import '../utils/permission_type.dart';

class GridCollageWidget extends StatefulWidget {
  final CollageType _collageType;
  final CollageBloc _imageListBloc;

  BuildContext _context;

  GridCollageWidget(this._collageType, this._imageListBloc, this._context,
      {Key? key})
      : super(key: key);

  @override
  State<GridCollageWidget> createState() => _GridCollageWidgetState();
}

class _GridCollageWidgetState extends State<GridCollageWidget> {
  var _imageList = <Images>[];
  double dividerWidth = 0;
  double dividerHeight = 0;
  double _scale = 1.0;

  double dividerWidthOfFour1 = 4;

  double dividerWidthOfFour2 = 8;
  double dividerHeightOfFour1 = 4;

  double dividerHeightOfFour2 = 8;
  String imagePath = '';
  String fileName = '';
  File? file;
  bool _startLoading = false;

  double? _previousScale;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    widget._context = context;
    //   if (_imageListBloc.state is ImageListState) {
    //  _imageList = (_imageListBloc.state as ImageListState).images;
    // imageGlobal = _imageList;

    return Stack(
      children: [
        SizedBox(
          height: 450,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  int check = imageGlobal
                      .indexWhere((element) => element.imageUrl == null);
                  if (check != -1) {
                    showDialog(
                        useSafeArea: false,
                        context: context,
                        barrierColor: Colors.black.withOpacity(0.7),
                        builder: (context) => AlertDialog(
                              iconPadding: EdgeInsets.zero,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(20, 20, 20, 10),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Please choose enough photos",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    dismissDialog();
                                  },
                                  child: Text("Cancel"),
                                )
                              ],
                            ));
                  } else {
                    setState(() {
                      _startLoading = true;
                    });
                    Future.delayed(const Duration(milliseconds: 200), () async {
                      imagePath = '';
                      if (Platform.isAndroid) {
                        imagePath = (await getExternalStorageDirectory())!
                            .path
                            .trim(); //from path_provide package
                      } else if (Platform.isIOS) {
                        imagePath = (await getApplicationDocumentsDirectory())
                            .path
                            .trim();
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
                          _startLoading = false;
                        });
                        await GallerySaver.saveImage(file!.path.toString(),
                            albumName: 'AplusPhoto');
                        screenshotController
                            .capture(delay: const Duration(milliseconds: 10))
                            .then((capturedImage) async {
                          showCapturedWidget(context, capturedImage!);
                        }).catchError((onError) {
                          print(onError);
                        });
                      }
                    });
                  }
                },
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Center(
                    child: Text("Save",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white)),
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Screenshot(
                        controller: screenshotController,
                        child: StaggeredGridView.countBuilder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: false,
                            itemCount: imageGlobal.length,
                            crossAxisCount:
                                getCrossAxisCount(widget._collageType),
                            primary: true,
                            itemBuilder: (BuildContext context, int index) =>
                                buildRow(index),
                            staggeredTileBuilder: (int index) =>
                                StaggeredTile.count(
                                    getCellCount(
                                        index: index,
                                        isForCrossAxis: true,
                                        type: widget._collageType),
                                    double.parse(getCellCount(
                                            index: index,
                                            isForCrossAxis: false,
                                            type: widget._collageType)
                                        .toString()))),
                      ),
                    ),
                    buildSlider(widget._collageType)
                  ],
                ),
              ),
            ],
          ),
        ),
        if (_startLoading)
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
    );
    //}
    //return Container(
    //  color: Colors.green,
    //);
  }

  Future<dynamic> showCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
        useSafeArea: false,
        context: context,
        barrierColor: Colors.black.withOpacity(0.7),
        builder: (context) => AlertDialog(
              backgroundColor: Colors.black.withOpacity(0.6),
              content: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('SUCCESS !!!',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 18,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),
                    Image.memory(capturedImage),
                    const SizedBox(height: 20),
                    const Text('Would you like to share\nthis image?',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    const SizedBox(height: 5),
                    GestureDetector(
                      onTap: () {
                        try {
                          Share.shareXFiles([XFile(file!.path)]);
                        } on PlatformException catch (e) {
                          print('Platform Exception: ${e.toString()}');
                        } catch (e) {
                          print('Exception: $e');
                        }
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                          child: Text(
                            'Share',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  Widget buildSlider(CollageType type) {
    Widget slider = Container();
    switch (type) {
      case CollageType.VSplit:
        slider = horizontalSlider(bottom: 0);
        break;
      case CollageType.HSplit:
        slider = verticalSlider(right: 5);
        break;
      case CollageType.FourSquare:
        slider = threeImageSlider(right: 5, bottom: 0);
        break;

      case CollageType.ThreeVerticalLeft:
        slider = threeImageSlider(right: 5, bottom: 0);
        break;
      case CollageType.ThreeVerticalRight:
        slider = threeImageSlider(left: 5, bottom: 0);
        break;

      case CollageType.ThreeHorizontalTop:
        slider = threeImageSlider(left: 5, bottom: 0);
        break;
      case CollageType.ThreeHorizontalBottom:
        slider = threeImageSlider(left: 5, top: 5);
        break;
      case CollageType.FourLeftBig:
        slider = fourImageSlider(right: 5, bottom: 0, left: 5, isLeft: true);
        break;
      case CollageType.FourRightBig:
        slider = fourImageSlider(right: 5, bottom: 0, left: 5, isLeft: false);
        break;
      case CollageType.FourTopBig:
        slider = fourImageSliderTopAndBottom(
            right: 5, bottom: 0, top: 5, isTop: true);
        break;
      case CollageType.FourBottomBig:
        slider = fourImageSliderTopAndBottom(
            right: 5, bottom: 0, top: 5, isTop: false);
        break;
    }

    return slider;
  }

  ///Find cross axis count for arrange items to Grid
  getCrossAxisCount(CollageType type) {
    if (type == CollageType.HSplit ||
        type == CollageType.VSplit ||
        type == CollageType.ThreeHorizontalTop ||
        type == CollageType.ThreeHorizontalBottom ||
        type == CollageType.ThreeVerticalRight ||
        type == CollageType.ThreeVerticalLeft) {
      return 10;
    } else if (type == CollageType.FourSquare ||
        type == CollageType.FourLeftBig ||
        type == CollageType.FourRightBig ||
        type == CollageType.FourBottomBig ||
        type == CollageType.FourTopBig) {
      return 12;
    }
  }

  ///Build UI either image is selected or not
  buildRow(int index) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Positioned.fill(
            bottom: 0.0,
            child: imageGlobal[index].imageUrl != null
                ? GestureDetector(
                    onTap: () {
                      showDialogImage(index);
                    },
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 6,
                      child: Image.file(
                        imageGlobal[index].imageUrl ?? File(''),
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      print(index);
                      showDialogImage(index);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Material(
                        child: Icon(Icons.add),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Color(0xFFD3D3D3),
                      ),
                    ),
                  )),
      ],
    );
  }

  ///Show bottom sheet
  showDialogImage(int index) {
    showModalBottomSheet(
        context: widget._context,
        builder: (BuildContext context) {
          return Container(
            color: const Color(0xFF737373),
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))),
              child: Padding(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildDialogOption(index, isForStorage: false),
                    buildDialogOption(index),
                    imageGlobal[index].imageUrl != null
                        ? buildDialogOption(index, isForRemovePhoto: true)
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  ///Show dialog
  Widget buildDialogOption(int index,
      {bool isForStorage = true, bool isForRemovePhoto = false}) {
    return TextButton(
        onPressed: () {
          dismissDialog();
          isForRemovePhoto
              ? widget._imageListBloc.dispatchRemovePhotoEvent(index)
              : widget._imageListBloc.add(
                  CheckPermissionEvent(
                    true,
                    isForStorage
                        ? PermissionType.Storage
                        : PermissionType.Camera,
                    index,
                  ),
                );
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  isForRemovePhoto
                      ? Icons.clear
                      : isForStorage
                          ? Icons.photo_album
                          : Icons.add_a_photo,
                  color: isForRemovePhoto
                      ? Colors.red
                      : isForStorage
                          ? Colors.amber
                          : Colors.blue,
                ),
              ),
              Text(isForRemovePhoto
                  ? "Remove"
                  : isForStorage
                      ? "Gallery"
                      : "Camera")
            ],
          ),
        ));
  }

  ///Dismiss dialog
  dismissDialog() {
    Navigator.of(widget._context, rootNavigator: true).pop(true);
  }

  /// @param index:- index of image.
  /// @param isForCrossAxis = if from cross axis count = true
  /// Note:- If row == column then crossAxisCount = row*column // rowCount or columnCount
  /// e.g. row = 3 and column = 3 then crossAxisCount = 3*3(9) or 3
  getCellCount(
      {required int index,
      required bool isForCrossAxis,
      required CollageType type}) {
    /// total cell count :- 2
    /// Column and Row :- 2*1 = 2 (Cross axis count)

    if (type == CollageType.VSplit) {
      if (isForCrossAxis) {
        /// Cross axis cell count
        return index == 0
            ? 5 + dividerWidth.toInt()
            : 10 - 5 - dividerWidth.toInt();
      } else {
        /// Main axis cell count
        return 10;
      }
    }

    /// total cell count :- 2
    /// Column and Row :- 1*2 = 2 (Cross axis count)

    else if (type == CollageType.HSplit) {
      if (isForCrossAxis) {
        /// Cross axis cell count
        return 10;
      } else {
        /// Main axis cell count
        return index == 0
            ? 5 + dividerHeight.toInt()
            : 10 - 5 - dividerHeight.toInt();
      }
    }

    /// total cell count :- 4
    /// Column and Row :- 2*2 (Cross axis count)

    else if (type == CollageType.FourSquare) {
      /// cross axis and main axis cell count

      if (isForCrossAxis) {
        return index == 0 || index == 2
            ? 6 + dividerWidth.toInt()
            : 12 - 6 - dividerWidth.toInt();
      } else {
        return index == 0 || index == 1
            ? 6 + dividerHeight.toInt()
            : 12 - 6 - dividerHeight.toInt();
      }
    }

    /// total cell count :- 9
    /// Column and Row :- 3*3 (Cross axis count)

    /// total cell count :- 3
    /// Column and Row :- 2 * 2
    /// First index taking 2 cell count in main axis and also in cross axis.
    else if (type == CollageType.ThreeVerticalLeft) {
      if (isForCrossAxis) {
        return index == 0
            ? 5 + dividerWidth.toInt()
            : 10 - 5 - dividerWidth.toInt();
      } else {
        return (index == 0)
            ? 10
            : index == 1
                ? 5 + dividerHeight.toInt()
                : 10 - 5 - dividerHeight.toInt();
      }
    } else if (type == CollageType.ThreeHorizontalTop) {
      if (isForCrossAxis) {
        return (index == 0)
            ? 10
            : index == 1
                ? 5 + dividerWidth.toInt()
                : 10 - 5 - dividerWidth.toInt();
      } else {
        return index == 0
            ? 5 + dividerHeight.toInt()
            : 10 - 5 - dividerHeight.toInt();
      }
    } else if (type == CollageType.ThreeHorizontalBottom) {
      if (isForCrossAxis) {
        return (index == 2)
            ? 10
            : index == 0
                ? 5 + dividerWidth.toInt()
                : 10 - 5 - dividerWidth.toInt();
      } else {
        return index == 2
            ? 10 - 5 - dividerHeight.toInt()
            : 5 + dividerHeight.toInt();
      }
    } else if (type == CollageType.ThreeVerticalRight) {
      if (isForCrossAxis) {
        return index == 1
            ? 10 - 5 - dividerWidth.toInt()
            : 5 + dividerWidth.toInt();
      } else {
        return (index == 1)
            ? 10
            : index == 0
                ? 5 + dividerHeight.toInt()
                : 10 - 5 - dividerHeight.toInt();
      }
    }

    /// total cell count :- 6
    /// Column and Row :- 3 * 3
    /// First index taking 2 cell in main axis and also in cross axis.
    /// Cross axis count = 3
    else if (type == CollageType.FourLeftBig) {
      if (isForCrossAxis) {
        return (index == 0)
            ? dividerWidthOfFour2.toInt()
            : 12 - dividerWidthOfFour2.toInt();
      } else {
        return (index == 0)
            ? 12
            : index == 1
                ? dividerHeightOfFour1.toInt()
                : index == 3
                    ? 12 - dividerHeightOfFour2.toInt()
                    : dividerHeightOfFour2.toInt() -
                        dividerHeightOfFour1.toInt();
      }
    } else if (type == CollageType.FourRightBig) {
      if (isForCrossAxis) {
        return (index == 1)
            ? 12 - dividerWidthOfFour1.toInt()
            : dividerWidthOfFour1.toInt();
      } else {
        return (index == 1)
            ? 12
            : index == 0
                ? dividerHeightOfFour1.toInt()
                : index == 3
                    ? 12 - dividerHeightOfFour2.toInt()
                    : dividerHeightOfFour2.toInt() -
                        dividerHeightOfFour1.toInt();
      }
    } else if (type == CollageType.FourTopBig) {
      if (isForCrossAxis) {
        return (index == 0)
            ? 12
            : index == 1
                ? dividerWidthOfFour1.toInt()
                : index == 3
                    ? 12 - dividerWidthOfFour2.toInt()
                    : dividerWidthOfFour2.toInt() - dividerWidthOfFour1.toInt();
      } else {
        return (index == 0)
            ? dividerHeightOfFour2.toInt()
            : 12 - dividerHeightOfFour2.toInt();
      }
    } else if (type == CollageType.FourBottomBig) {
      if (isForCrossAxis) {
        return (index == 3)
            ? 12
            : index == 0
                ? dividerWidthOfFour1.toInt()
                : index == 2
                    ? 12 - dividerWidthOfFour2.toInt()
                    : dividerWidthOfFour2.toInt() - dividerWidthOfFour1.toInt();
      } else {
        return (index == 3)
            ? 12 - dividerHeightOfFour1.toInt()
            : dividerHeightOfFour1.toInt();
      }
    }
  }

  ///Show image picker dialog
  imagePickerDialog(int index) {
    showDialog(
        context: widget._context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildDialogOption(index, isForStorage: false),
                  buildDialogOption(index),
                  (widget._imageListBloc.state as ImageListState)
                              .images[index]
                              .imageUrl !=
                          null
                      ? buildDialogOption(index, isForRemovePhoto: true)
                      : Container(),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  dismissDialog();
                },
                child: Text("Cancel"),
              )
            ],
          );
        });
  }

  Widget horizontalSlider({double? top, double? bottom}) {
    return Positioned(
        top: top,
        bottom: bottom,
        child: SizedBox(
          height: 10,
          width: MediaQuery.of(context).size.width,
          child: RotatedBox(
            quarterTurns: 0,
            child: SliderTheme(
              data: const SliderThemeData(
                  trackShape: RectangularSliderTrackShape(), trackHeight: 4),
              child: Slider(
                  inactiveColor: Colors.yellow,
                  activeColor: Colors.yellow,
                  min: -5,
                  max: 5,
                  value: dividerWidth,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      if (value > 3) {
                        dividerWidth = 3;
                      } else if (value < -3) {
                        dividerWidth = -3;
                      } else {
                        dividerWidth = value;
                      }
                    });
                  }),
            ),
          ),
        ));
  }

  Widget verticalSlider({double? left, double? right}) {
    return Positioned(
        left: left,
        right: right,
        bottom: 0,
        child: SizedBox(
          height: 400,
          width: 10,
          child: RotatedBox(
            quarterTurns: 1,
            child: SliderTheme(
              data: const SliderThemeData(
                  trackShape: RectangularSliderTrackShape(), trackHeight: 4),
              child: Slider(
                  inactiveColor: Colors.yellow,
                  activeColor: Colors.yellow,
                  min: -5,
                  max: 5,
                  value: dividerHeight,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      if (value > 3) {
                        dividerHeight = 3;
                      } else if (value < -3) {
                        dividerHeight = -3;
                      } else {
                        dividerHeight = value;
                      }
                    });
                  }),
            ),
          ),
        ));
  }

  Widget threeImageSlider(
      {double? top, double? bottom, double? left, double? right}) {
    return Stack(children: [
      verticalSlider(right: right, left: left),
      horizontalSlider(bottom: bottom, top: top)
    ]);
  }

  Widget fourImageSlider(
      {double? top,
      double? bottom,
      double? left,
      double? right,
      required bool isLeft}) {
    return Stack(children: [
      Positioned(
          bottom: bottom,
          child: SizedBox(
            height: 10,
            width: MediaQuery.of(context).size.width,
            child: RotatedBox(
              quarterTurns: 0,
              child: SliderTheme(
                data: const SliderThemeData(
                    trackShape: RectangularSliderTrackShape(), trackHeight: 4),
                child: Slider(
                    inactiveColor: Colors.yellow,
                    activeColor: Colors.yellow,
                    min: 0,
                    max: 12,
                    value: isLeft ? dividerWidthOfFour2 : dividerWidthOfFour1,
                    divisions: 12,
                    onChanged: (value) {
                      setState(isLeft
                          ? () {
                              if (value > 9) {
                                dividerWidthOfFour2 = 9;
                              } else if (value < 3) {
                                dividerWidthOfFour2 = 3;
                              } else {
                                dividerWidthOfFour2 = value;
                              }
                            }
                          : () {
                              if (value > 9) {
                                dividerWidthOfFour1 = 9;
                              } else if (value < 3) {
                                dividerWidthOfFour1 = 3;
                              } else {
                                dividerWidthOfFour1 = value;
                              }
                            });
                    }),
              ),
            ),
          )),
      Positioned(
          left: left,
          child: SizedBox(
            width: 10,
            height: 400,
            child: RotatedBox(
              quarterTurns: 1,
              child: SliderTheme(
                data: const SliderThemeData(
                    trackShape: RectangularSliderTrackShape(), trackHeight: 4),
                child: Slider(
                    inactiveColor: Colors.yellow,
                    activeColor: Colors.yellow,
                    min: 0,
                    max: 12,
                    value: dividerHeightOfFour1,
                    divisions: 12,
                    onChanged: (value) {
                      if (dividerHeightOfFour2 - value >= 3) {
                        setState(() {
                          if (value < 3) {
                            dividerHeightOfFour1 = 3;
                          } else {
                            dividerHeightOfFour1 = value;
                          }
                        });
                      }
                    }),
              ),
            ),
          )),
      Positioned(
          right: right,
          child: SizedBox(
            width: 10,
            height: 400,
            child: RotatedBox(
              quarterTurns: 1,
              child: SliderTheme(
                data: const SliderThemeData(
                    trackShape: RectangularSliderTrackShape(), trackHeight: 4),
                child: Slider(
                    inactiveColor: Colors.yellow,
                    activeColor: Colors.yellow,
                    min: 0,
                    max: 12,
                    value: dividerHeightOfFour2,
                    divisions: 12,
                    onChanged: (value) {
                      if (value - dividerHeightOfFour1 >= 3) {
                        setState(() {
                          if (value > 9) {
                            dividerHeightOfFour2 = 9;
                          } else {
                            dividerHeightOfFour2 = value;
                          }
                        });
                      }
                    }),
              ),
            ),
          ))
    ]);
  }

  Widget fourImageSliderTopAndBottom(
      {double? top, double? bottom, double? right, required bool isTop}) {
    return Stack(children: [
      Positioned(
          top: top,
          child: SizedBox(
            height: 10,
            width: MediaQuery.of(context).size.width,
            child: RotatedBox(
              quarterTurns: 0,
              child: SliderTheme(
                data: const SliderThemeData(
                    trackShape: RectangularSliderTrackShape(), trackHeight: 4),
                child: Slider(
                    inactiveColor: Colors.yellow,
                    activeColor: Colors.yellow,
                    min: 0,
                    max: 12,
                    value: dividerWidthOfFour1,
                    divisions: 12,
                    onChanged: (value) {
                      setState(() {
                        if (dividerWidthOfFour2 - value >= 3) {
                          if (value < 3) {
                            dividerWidthOfFour1 = 3;
                          } else {
                            dividerWidthOfFour1 = value;
                          }
                        }
                      });
                    }),
              ),
            ),
          )),
      Positioned(
          bottom: bottom,
          child: SizedBox(
            height: 10,
            width: MediaQuery.of(context).size.width,
            child: RotatedBox(
              quarterTurns: 0,
              child: SliderTheme(
                data: const SliderThemeData(
                    trackShape: RectangularSliderTrackShape(), trackHeight: 4),
                child: Slider(
                    inactiveColor: Colors.yellow,
                    activeColor: Colors.yellow,
                    min: 0,
                    max: 12,
                    value: dividerWidthOfFour2,
                    divisions: 12,
                    onChanged: (value) {
                      if (value - dividerWidthOfFour1 >= 3) {
                        setState(() {
                          if (value > 9) {
                            dividerWidthOfFour2 = 9;
                          } else {
                            dividerWidthOfFour2 = value;
                          }
                        });
                      }
                    }),
              ),
            ),
          )),
      Positioned(
          right: right,
          child: SizedBox(
            height: 400,
            width: 10,
            child: RotatedBox(
              quarterTurns: 1,
              child: SliderTheme(
                data: const SliderThemeData(
                    trackShape: RectangularSliderTrackShape(), trackHeight: 4),
                child: Slider(
                    inactiveColor: Colors.yellow,
                    activeColor: Colors.yellow,
                    min: 0,
                    max: 12,
                    value: isTop ? dividerHeightOfFour2 : dividerHeightOfFour1,
                    divisions: 12,
                    onChanged: (value) {
                      setState(isTop
                          ? () {
                              if (value > 9) {
                                dividerHeightOfFour2 = 9;
                              } else if (value < 3) {
                                dividerHeightOfFour2 = 3;
                              } else {
                                dividerHeightOfFour2 = value;
                              }
                            }
                          : () {
                              if (value > 9) {
                                dividerHeightOfFour1 = 9;
                              } else if (value < 3) {
                                dividerHeightOfFour1 = 3;
                              } else {
                                dividerHeightOfFour1 = value;
                              }
                            });
                    }),
              ),
            ),
          )),
    ]);
  }
}
