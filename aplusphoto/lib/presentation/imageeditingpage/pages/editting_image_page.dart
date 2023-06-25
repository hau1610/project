import 'package:aplusphoto/common/global_instance.dart';
import 'package:aplusphoto/presentation/imageeditingpage/pages/crop_image/crop_image.dart';
import 'package:aplusphoto/presentation/imageeditingpage/pages/filter_image/filter_image_page.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../homepage/bloc/homepage_bloc.dart';
import '../../homepage/bloc/homepage_state.dart';
import '../blocs/image_editting_page_bloc.dart';
import '../blocs/image_editting_page_event.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage>
    with SingleTickerProviderStateMixin {
  int selectedPage = reset ? indexTab : 0;
  late TabController _tabController;

  void changeTab(int index) {
    setState(() {
      selectedPage = index;
      indexTab = index;
      _tabController.animateTo(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: reset ? indexTab : 0, vsync: this, length: 4);
    reset = false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context
            .read<ImageEdittingBloc>()
            .add(UpdateCropImage(image: Container()));
        return true;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          bottomNavigationBar: ConvexAppBar(
            color: Colors.white,
            backgroundColor: const Color.fromRGBO(59, 58, 58, 1),
            height: 40,
            activeColor: Colors.yellow,
            style: TabStyle.flip,
            initialActiveIndex: 0,
            controller: _tabController,
            items: [
              TabItem(
                  icon: Icon(
                    Icons.crop,
                    size: 22,
                    color: selectedPage == 0 ? Colors.yellow : Colors.white,
                  ),
                  title: 'Crop'),
              TabItem(
                  icon: Icon(
                    Icons.filter,
                    size: 22,
                    color: selectedPage == 1 ? Colors.yellow : Colors.white,
                  ),
                  title: 'Filter'),
              TabItem(
                  icon: Icon(
                    Icons.palette_rounded,
                    size: 22,
                    color: selectedPage == 2 ? Colors.yellow : Colors.white,
                  ),
                  title: 'Scribble'),
              TabItem(
                  icon: Icon(
                    Icons.fitbit_outlined,
                    size: 22,
                    color: selectedPage == 3 ? Colors.yellow : Colors.white,
                  ),
                  title: 'Setting'),
            ],
            onTap: (int i) {
              if (i != selectedPage) {
                changeTab(i);
              }
            },
          ),
          body: BlocBuilder<HomePageBloc, HomePageState>(
            builder: (context, state) {
              return state is UploadImageSuccess
                  ? IndexedStack(
                      index: selectedPage == 0 ? 0 : 1,
                      children: [
                        CropImagePage(
                          pathImage: state.image,
                          changeBottombar: changeTab,
                        ),
                        FilterImagePage(
                          pathImage: state.image,
                        )
                      ],
                    )
                  : Container();
            },
          )),
    );
  }
}
