import 'package:aplusphoto/presentation/homepage/bloc/homepage_bloc.dart';
import 'package:aplusphoto/presentation/imageeditingpage/blocs/image_editting_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'app_routes.dart';

void main() {
  runApp(MultiBlocProvider(providers: [
    BlocProvider<HomePageBloc>(create: (context) => HomePageBloc()),
    BlocProvider<ImageEdittingBloc>(create: (context) => ImageEdittingBloc()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        enableLog: true,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/introduction',
        getPages: AppRoutes.routes);
  }
}
