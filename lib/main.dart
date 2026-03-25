import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teste/Binding/initialBinding.dart';
import 'package:teste/Pages/CreatePage.dart';
import 'package:teste/Pages/EditPage.dart';
import 'package:teste/Pages/HomePage.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      defaultTransition: Transition.native,
      initialBinding: InitialBinding(),
      locale: Locale('pt', 'BR'),
      getPages: [
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/create', page: () => CreatePage()),
        GetPage(name: '/edit', page: () => EditPage()),
      ],
    ),
  );
}
