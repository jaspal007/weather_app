import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  Stream stream = const Stream.empty();

  TextEditingController cityController = TextEditingController();
  bool isNull = true;

  Future<void> cityResponse() async {
    var url = Uri.parse(
        "https://api.mapbox.com/search/searchbox/v1/suggest?q=${cityController.text}&language=en&session_token=0e511749-3c49-4e71-88a5-f818dc80d812&access_token=pk.eyJ1IjoibTFja2V5MDA3IiwiYSI6ImNsbTRvNWpsajBqMGEzZnFvb3E2cnYyNDYifQ.eS9ZbgMGRbFTh2lJK_LXIQ");
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        setState(() {
          String data = response.body;
          stream = jsonDecode(data)["suggestions"];
          // for (var item in stream)
          //   print("${item["name"]} + ${item["place_formatted"]}");
        });
      } else {
        print("failed");
      }
    } on HttpException catch (error) {
      print(error.message);
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    cityController.addListener(() {
      setState(() {
        if (cityController.text.isEmpty) {
          isNull = true;
        } else {
          isNull = false;
          cityResponse();
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double keyboard = MediaQuery.of(context).viewInsets.bottom;
    double height = MediaQuery.of(context).size.height;
    return (orientation == Orientation.portrait)
        ? Container(
            margin: const EdgeInsets.only(
              top: 40,
              left: 10,
              right: 10,
            ),
            height: height * 0.8,
            child: SizedBox(
              // color: Colors.red,
              child: Column(
                children: [
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: (isNull)
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  cityController.clear();
                                  isNull = true;
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(
                    height: height * 0.7 - keyboard,
                    child: StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator.adaptive();
                        }
                        if (snapshot.hasData) {
                          var documents = snapshot.data!.docs;
                          return ListView.builder(
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              ListTile(
                                title: Text(
                                  "${documents[index]["name"]}",
                                ),
                                subtitle: Text(
                                  "${documents[index]["place_formatted"]}",
                                ),
                              );
                            },
                          );
                        }
                        return const Text(
                          "Type something to search",
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            margin: const EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
            ),
            height: height,
            child: SizedBox(
              // color: Colors.red,
              child: Column(
                children: [
                  TextField(
                    controller: cityController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                      ),
                      suffixIcon: (isNull)
                          ? null
                          : IconButton(
                              onPressed: () {
                                setState(() {
                                  cityController.clear();
                                  isNull = true;
                                });
                              },
                              icon: const Icon(
                                Icons.clear,
                              ),
                            ),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 5,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(
                    height: height * 0.7 - keyboard,
                    child: StreamBuilder(
                      stream: stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator.adaptive();
                        }
                        if (snapshot.hasData) {
                          var documents = snapshot.data!.docs;
                          return Expanded(
                            child: ListView.builder(
                              itemCount: documents.length,
                              itemBuilder: (context, index) {
                                ListTile(
                                  title: Text(
                                    "${documents[index]["name"]}",
                                  ),
                                  subtitle: Text(
                                    "${documents[index]["place_formatted"]}",
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return const Expanded(
                          child: Text(
                            "Type something to search",
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
