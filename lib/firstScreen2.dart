// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'package:assignment_heliverse/secondScreen.dart';
import 'package:assignment_heliverse/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:assignment_heliverse/data.dart';
import 'package:get/get.dart';

class FirstScreen2 extends StatefulWidget {
  const FirstScreen2({Key? key}) : super(key: key);

  @override
  State<FirstScreen2> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen2> {
  final TextStyle Txtstyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.w500);
  final TextEditingController searchController = TextEditingController();
  List<Data> searchedusers = [];
  List<Data> dataModel = [];
  int currentPage = 1;
  int itemsPerPage = 10;
  bool isAtEndOfList = false;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  Future<List<Data>> getData() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/data/data.json");
    List mapData = jsonDecode(data);
    print(mapData);
    List<Data> details =
        mapData.map((detail) => Data.fromJson(detail)).toList();
    dataModel = details;
    return details;
  }

  @override
  void initState() {
    getData();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        isAtEndOfList = true;
      });
      await currentPage++;
      setState(() {
        isAtEndOfList = false;
      });
    }
  }

  String domain = '';
  String gender = '';
  String available = '';
  List<String> list = [];
  String s1 = "";
  String s2 = "";
  String s3 = "";

  void searchfromData(String query) async {
    searchedusers.clear();
    for (var element in dataModel) {
      var domain = element.domain!.toLowerCase();
      var gender = element.gender!.toLowerCase();
      var available = element.available!.toString().toLowerCase();
      if (domain.contains(query.toLowerCase())) {
        searchedusers.add(element);
      } else if (gender.contains(query.toLowerCase())) {
        searchedusers.add(element);
      } else if (available.contains(query.toLowerCase())) {
        searchedusers.add(element);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade500,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Get.to(SecondScreen());
                },
                icon: Icon(Icons.people_alt_outlined))
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search Users',
                prefixIcon: Icon(Icons.search),
                prefixIconColor: Colors.black,
              ),
              onChanged: (query) => {
                setState(() {
                  if ((searchController.text).replaceAll(" ", "") == "") {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => FirstScreen2()),
                        (route) => false);
                  }
                  domain = query;
                  gender = query;
                  available = query;
                  searchfromData(query);
                }),
              },
            ),
          ),
          Expanded(
            child: searchedusers.isEmpty ||
                    domain.isEmpty ||
                    gender.isEmpty ||
                    available.isEmpty
                ? FutureBuilder<List<Data>>(
                    future: getData(),
                    builder: (context, data) {
                      if (data.hasData) {
                        List<Data> credential = data.data!;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: _scrollController,
                          padding: EdgeInsets.all(8),
                          itemCount: isAtEndOfList
                              ? currentPage * itemsPerPage + 1
                              : currentPage * itemsPerPage,
                          itemBuilder: (context, index) {
                            if (index < credential.length) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                elevation: 5,
                                child: ExpansionTile(
                                  backgroundColor: Colors.yellow.shade100,
                                  leading: CircleAvatar(
                                    radius: 25,
                                    child: Image.network(
                                      credential[index].avatar!,
                                    ),
                                  ),
                                  title: Text(
                                    '${credential[index].firstName!} ${credential[index].lastName!}',
                                    style: Txtstyle,
                                  ),
                                  subtitle: Text(
                                    credential[index].email!,
                                    style: Txtstyle,
                                  ),
                                  trailing: Text(
                                    credential[index].gender!,
                                    style: Txtstyle,
                                  ),
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                credential[index].domain!,
                                                style: Txtstyle,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                credential[index].available!
                                                    ? "Available"
                                                    : "Not Available",
                                                style: Txtstyle,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: () {
                                              final user = credential[index];
                                              if (user.available ?? false) {
                                                Get.find<UserController>()
                                                    .addUser(user);
                                              } else {
                                                Get.snackbar(
                                                  animationDuration: Duration(
                                                      milliseconds: 500),
                                                  'Not Available',
                                                  'This user is not available.',
                                                  backgroundColor: Colors.white
                                                      .withOpacity(0.5),
                                                  snackPosition:
                                                      SnackPosition.TOP,
                                                );
                                              }
                                            },
                                            child: Container(
                                              width: 130,
                                              height: 40,
                                              decoration: ShapeDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment(0.00, -1.00),
                                                  end: Alignment(0, 1),
                                                  colors: [
                                                    Color(0xFF178FFF),
                                                    Color(0x661D8CF2)
                                                  ],
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                      color: Color(0x7F499CC0)),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                shadows: [
                                                  BoxShadow(
                                                    color: Color(0x3F000000),
                                                    blurRadius: 10,
                                                    offset: Offset(0, 4),
                                                    spreadRadius: 0,
                                                  )
                                                ],
                                              ),
                                              child: Center(
                                                  child: Text(
                                                'Add To Team',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            } else {
                              return CircularProgressIndicator();
                            }
                          },
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    },
                  )
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    controller: _scrollController,
                    padding: EdgeInsets.all(8),
                    itemCount: currentPage * itemsPerPage,
                    itemBuilder: (context, index) {
                      if (index < searchedusers.length) {
                        return Card(
                          child: ExpansionTile(
                            backgroundColor: Colors.yellow.shade100,
                            leading: CircleAvatar(
                              radius: 25,
                              child: Image.network(
                                searchedusers[index].avatar!,
                              ),
                            ),
                            title: Text(
                              '${searchedusers[index].firstName!} ${searchedusers[index].lastName!}',
                              style: Txtstyle,
                            ),
                            subtitle: Text(
                              searchedusers[index].email!,
                              style: Txtstyle,
                            ),
                            trailing: Text(
                              searchedusers[index].gender!,
                              style: Txtstyle,
                            ),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          searchedusers[index].domain!,
                                          style: Txtstyle,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          searchedusers[index].available!
                                              ? "Available"
                                              : "Not Available",
                                          style: Txtstyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: InkWell(
                                      onTap: () {
                                        final user = searchedusers[index];
                                        if (user.available ?? false) {
                                          Get.find<UserController>()
                                              .addUser(user);
                                        } else {
                                          Get.snackbar(
                                            animationDuration:
                                                Duration(milliseconds: 500),
                                            'Not Available',
                                            'This user is not available.',
                                            backgroundColor:
                                                Colors.white.withOpacity(0.5),
                                            snackPosition: SnackPosition.TOP,
                                          );
                                        }
                                      },
                                      child: Container(
                                        width: 130,
                                        height: 40,
                                        decoration: ShapeDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment(0.00, -1.00),
                                            end: Alignment(0, 1),
                                            colors: [
                                              Color(0xFF178FFF),
                                              Color(0x661D8CF2)
                                            ],
                                          ),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0x7F499CC0)),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          shadows: [
                                            BoxShadow(
                                              color: Color(0x3F000000),
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        ),
                                        child: Center(
                                            child: Text(
                                          'Add To Team',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
