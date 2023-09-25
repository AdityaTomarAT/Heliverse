import 'package:assignment_heliverse/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final userList = <Data>[].obs;

  void addUser(Data user) {
    userList.add(user);
    Get.snackbar(
      animationDuration: Duration(milliseconds: 300),
      'Success',
      'User added successfully',
      backgroundColor: Colors.white.withOpacity(0.5),
      snackPosition: SnackPosition.TOP,
    );
  }
}
