import 'package:aplusphoto/presentation/homepage/bloc/homepage_bloc.dart';
import 'package:aplusphoto/presentation/homepage/bloc/homepage_event.dart';
import 'package:aplusphoto/presentation/homepage/bloc/homepage_state.dart';
import 'package:aplusphoto/presentation/imageeditingpage/pages/editting_image_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../common/global_instance.dart';
import '../../common/images/image.dart';
import '../../common/widgets/image_widget.dart';
import '../collage_background/collage_background.dart';
import '../collage_image/collage_image_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final List<String> introductions = [
      IconConstants.cropIntroduction,
      IconConstants.fillterIntroduction,
      IconConstants.stickerIntroduction,
      IconConstants.drawIntroduction,
      IconConstants.collageIntroduction,
      IconConstants.backgroundIntroduction,
    ];

    List<String> images = [
      IconConstants.cameraButton,
      IconConstants.libraryButton,
      IconConstants.collageButton,
      IconConstants.backgroundButton
    ];
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const ImageWidget(
            Picture.logo,
            width: 180,
          ),
        ),
        body: BlocListener<HomePageBloc, HomePageState>(
            listener: (context, state) {
              if (state is UploadImageSuccess) {
                Get.to(() => const FilterPage());
              }
            },
            child: SizedBox(
              height: height,
              width: width,
              child: ListView(
                children: [
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Introduction',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                      height: 280,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              margin: EdgeInsets.only(bottom: 20),
                              child: ImageWidget(introductions[index]));
                        },
                        pagination: SwiperPagination(
                            margin: const EdgeInsets.only(top: 40),
                            builder: DotSwiperPaginationBuilder(
                                size: 7,
                                color: Colors.grey.withOpacity(0.7),
                                activeColor: Colors.deepPurple)),
                        itemCount: introductions.length,
                        viewportFraction: 0.55,
                        scale: 0.8,
                        autoplay: true,
                      )),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categories',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 300,
                          child: GridView.count(
                            childAspectRatio: 3 / 2,
                            primary: false,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 20,
                            crossAxisCount: 2,
                            children: List.generate(
                                4,
                                (index) => GestureDetector(
                                      onTap: () {
                                        resetData();
                                        if (index == 0) {
                                          context.read<HomePageBloc>().add(
                                              const GetImageEvent(
                                                  source: ImageSource.camera));
                                        } else if (index == 1) {
                                          context.read<HomePageBloc>().add(
                                              const GetImageEvent(
                                                  source: ImageSource.gallery));
                                        } else if (index == 2) {
                                          Get.to(
                                              () => const CollageImagePage());
                                        } else {
                                          Get.to(
                                              () => const CollageBackground());
                                        }
                                      },
                                      child: ImageWidget(
                                        images[index],
                                        borderRadius: 20,
                                        fit: BoxFit.contain,
                                      ),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

Widget buildStatisticItem(String title, String value, Color circleColor) {
  return Row(
    children: [
      Container(
        height: 10,
        width: 10,
        decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
      ),
      const SizedBox(width: 5),
      Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey)),
          Text(value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ))
        ],
      ),
    ],
  );
}

void showOptions(BuildContext context) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
            height: 120,
            child: Column(children: <Widget>[
              ListTile(
                  tileColor: Colors.black.withOpacity(0.5),
                  textColor: const Color.fromRGBO(160, 169, 252, 1),
                  onTap: () {
                    context
                        .read<HomePageBloc>()
                        .add(const GetImageEvent(source: ImageSource.gallery));
                  },
                  leading: const Icon(
                    Icons.photo_library,
                    color: Color.fromRGBO(160, 169, 252, 1),
                  ),
                  title: const Text(
                    "Choose from photo library",
                    style: TextStyle(
                        color: Color.fromRGBO(160, 169, 252, 1),
                        fontWeight: FontWeight.w500),
                  )),
              ListTile(
                  textColor: const Color.fromRGBO(160, 169, 252, 1),
                  tileColor: Colors.black.withOpacity(0.5),
                  onTap: () {
                    context
                        .read<HomePageBloc>()
                        .add(const GetImageEvent(source: ImageSource.camera));
                  },
                  leading: const Icon(
                    Icons.camera_alt,
                    color: Color.fromRGBO(160, 169, 252, 1),
                  ),
                  title: const Text("Choose from camera",
                      style: TextStyle(
                          color: Color.fromRGBO(160, 169, 252, 1),
                          fontWeight: FontWeight.w500)))
            ]));
      });
}
