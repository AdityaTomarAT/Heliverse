// ignore_for_file: prefer_const_constructors

import 'package:assignment_heliverse/firstScreen.dart';
import 'package:assignment_heliverse/firstScreen2.dart';
import 'package:assignment_heliverse/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
  Get.put(UserController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: FirstScreen2(),
    );
  }
}
