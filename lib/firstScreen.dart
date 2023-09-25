// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:assignment_heliverse/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Data> searchedusers = [];
  List<Data> dataModel = [];

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
    super.initState();
  }

  String domain = '';
  String gender = '';
  String available = '';

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
        appBar: AppBar(
          backgroundColor: Colors.lightBlue.shade300,
        ),
        body: Column(
          children: [
            SafeArea(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(24)),
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
                          MaterialPageRoute(
                              builder: (context) => FirstScreen()),
                          (route) => false);
                    }
                    domain = query;
                    gender = query;
                    available = query;
                    searchfromData(query);
                  }),
                },
              ),
            )),
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
                                itemCount: credential.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 25,
                                      child: Image.network(
                                          credential[index].avatar!),
                                    ),
                                    title: Text(
                                        '${credential[index].firstName!} ${credential[index].lastName!}'),
                                    subtitle: Text(credential[index].email!),
                                    trailing: Column(
                                      children: [
                                        Text(credential[index].domain!),
                                        Text(credential[index].available!
                                            ? "Available"
                                            : "Not Available "),
                                        Text(credential[index].gender!)
                                      ],
                                    ),
                                  );
                                });
                          } else {
                            return CircularProgressIndicator();
                          }
                        })
                    : ListView.builder(
                        itemCount: searchedusers.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              child:
                                  Image.network(searchedusers[index].avatar!),
                            ),
                            title: Text(
                                '${searchedusers[index].firstName!} ${searchedusers[index].lastName!}'),
                            subtitle: Text(searchedusers[index].email!),
                            trailing: Column(
                              children: [
                                Text(searchedusers[index].domain!),
                                Text(searchedusers[index].available!
                                    ? "Available"
                                    : "Not Available"),
                                Text(searchedusers[index].gender!)
                              ],
                            ),
                          );
                        }))
          ],
        ));
  }
}
