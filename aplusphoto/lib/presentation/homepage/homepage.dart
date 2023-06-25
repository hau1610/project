import 'package:aplusphoto/presentation/homepage/bloc/homepage_bloc.dart';
import 'package:aplusphoto/presentation/homepage/bloc/homepage_event.dart';
import 'package:aplusphoto/presentation/homepage/bloc/homepage_state.dart';
import 'package:aplusphoto/presentation/imageeditingpage/pages/editting_image_page.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

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
    final List<String> categories = [
      'Camera',
      'Gallery',
      'Collage',
      'Background'
    ];
    final List<String> icons = [
      Picture.camera,
      Picture.photo,
      Picture.collage,
      Picture.addBackground
    ];
    final List<Color> colors = [
      const Color.fromRGBO(113, 195, 249, 1),
      const Color.fromRGBO(255, 117, 159, 1),
      Colors.orange,
      const Color.fromRGBO(83, 225, 59, 1),
    ];

    List<String> images = [
      'https://znews-photo.zingcdn.me/w860/Uploaded/mdf_eioxrd/2021_07_06/2.jpg',
      'https://kenh14cdn.com/thumb_w/660/2020/7/17/brvn-15950048783381206275371.jpg',
      'https://cdn.alongwalk.info/vn/wp-content/uploads/2022/04/27034030/image-dung-hinh-ha-giang-thang-9-dep-me-man-trong-moi-khung-hinh-cua-dan-me-phuot-165098043084633.jpg',
      'https://img.meta.com.vn/Data/image/2022/01/13/anh-dep-thien-nhien-10.jpg'
    ];
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const ImageWidget(
            Picture.logo,
            width: 150,
          ),
          actions: [
            GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Icon(Icons.logout,
                      size: 18, color: Colors.black.withOpacity(0.7)),
                ))
          ],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'My Images',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '10 images',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.blue.withOpacity(0.3)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                      height: 200,
                      child: Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: ImageWidget(
                              images[index],
                              borderRadius: 20,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        pagination: SwiperPagination(
                            margin: const EdgeInsets.only(top: 40),
                            builder: DotSwiperPaginationBuilder(
                                size: 7,
                                color: Colors.grey.withOpacity(0.7),
                                activeColor: Colors.deepPurple)),
                        itemCount: images.length,
                        viewportFraction: 0.55,
                        scale: 0.8,
                        autoplay: true,
                      )),
                  const SizedBox(height: 40),
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
                          height: 20,
                        ),
                        SizedBox(
                          height: 150,
                          child: GridView.count(
                            childAspectRatio: 3,
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
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color:
                                                  Colors.grey.withOpacity(0.15),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 2,
                                                  height: 40,
                                                  color: colors[index],
                                                ),
                                                ImageWidget(
                                                  icons[index],
                                                  height: 30,
                                                  width: 30,
                                                ),
                                                Container()
                                              ],
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            categories[index],
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 150,
                              width: width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      width: 1,
                                      color: Colors.black.withOpacity(0.3))),
                              child: const ImageWidget(
                                Picture.greyBackground,
                                borderRadius: 20,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Text('Statistics',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                            )),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            buildStatisticItem(
                                                'Used', '0 GB', Colors.black),
                                            buildStatisticItem(
                                                'Total Files',
                                                '0',
                                                Colors.black.withOpacity(0.5))
                                          ],
                                        ),
                                        const SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            buildStatisticItem(
                                                'Time of day use',
                                                '10 hours',
                                                Colors.black.withOpacity(0.2)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  CircularPercentIndicator(
                                    radius: 60.0,
                                    animation: true,
                                    animationDuration: 1200,
                                    lineWidth: 18.0,
                                    percent: 10 / 24,
                                    center: new Text(
                                      "10 hours",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17.0),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    progressColor: Colors.deepPurple,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
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
