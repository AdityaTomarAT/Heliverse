// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:assignment_heliverse/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondScreen extends StatefulWidget {
  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final TextStyle Txtstyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text('Added Users'),
      ),
      body: GetX<UserController>(
        builder: (controller) {
          return ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: controller.userList.length,
            itemBuilder: (context, index) {
              final user = controller.userList[index];
              return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: ExpansionTile(
                    backgroundColor: Colors.yellow.shade100,
                    leading: CircleAvatar(
                      radius: 25,
                      child: Image.network(user.avatar!),
                    ),
                    title: Text(
                      '${user.firstName!} ${user.lastName!}',
                      style: Txtstyle,
                    ),
                    subtitle: Text(
                      user.email!,
                      style: Txtstyle,
                    ),
                    trailing: Text(
                      user.gender!,
                      style: Txtstyle,
                    ),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 20, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.domain!,
                                style: Txtstyle,
                              ),
                              Text(
                                user.available! ? "Available" : "Not Available",
                                style: Txtstyle,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ));
            },
          );
        },
      ),
    );
  }
}
