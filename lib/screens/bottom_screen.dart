import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/resources/global_variable.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  List<dynamic> stream = [];

  TextEditingController cityController = TextEditingController();
  bool isNull = true;

  Future<void> geoCode(
      String cityName, String stateCode, String countryCode) async {
    var url = Uri.parse(
        "http://api.openweathermap.org/geo/1.0/direct?q=$cityName,$stateCode,$countryCode&appid=$apiKey");
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        setState(() {
          String data = response.body;
          List geoCode = jsonDecode(data);
          if (geoCode.isNotEmpty) {
            longitude.value = geoCode[0]["lon"];
            latitude.value = geoCode[0]["lat"];
          } else {
            throw Exception("Place not found");
          }
        });
      } else {
        print("failed");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> cityResponse() async {
    var url = Uri.parse(
        "https://api.mapbox.com/search/searchbox/v1/suggest?q=${cityController.text}&language=en&session_token=0e511749-3c49-4e71-88a5-f818dc80d812&access_token=pk.eyJ1IjoibTFja2V5MDA3IiwiYSI6ImNsbTRvNWpsajBqMGEzZnFvb3E2cnYyNDYifQ.eS9ZbgMGRbFTh2lJK_LXIQ");
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        setState(() {
          String data = response.body;
          final cities = jsonDecode(data)["suggestions"];
          stream = cities;
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
                                  stream.clear();
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
                    // color: Colors.rd,
                    height: (height * 0.7) - keyboard,
                    child: (stream.isEmpty)
                        ? const Center(
                            child: Text("Type to suggest"),
                          )
                        : ListView.builder(
                            itemCount: stream.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  print("tapped");
                                  try {
                                    final data = stream[index]["context"];
                                    if (data["country"]["country_code"]
                                            .toString()
                                            .isNotEmpty &&
                                        data["region"]["region_code"]
                                            .toString()
                                            .isNotEmpty) {
                                      geoCode(
                                        stream[index]["name"],
                                        data["region"]["region_code"],
                                        data["country"]["country_code"],
                                      ).whenComplete(
                                          () => Navigator.pop(context));
                                    }
                                  } catch (error) {
                                    showAdaptiveDialog(
                                      context: context,
                                      builder: (context) =>
                                          AlertDialog.adaptive(
                                        content: Text(error.toString()),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("OK")),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                title: Text(
                                  "${stream[index]["name"]}",
                                ),
                                subtitle: Text(
                                  "${stream[index]["place_formatted"]}",
                                ),
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
                    child: (stream.isEmpty)
                        ? const Center(
                            child: Text("Type to suggest"),
                          )
                        : ListView.builder(
                            itemCount: stream.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  print("tapped");
                                  cityName.value = stream[index]["name"];
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  "${stream[index]["name"]}",
                                ),
                                subtitle: Text(
                                  "${stream[index]["place_formatted"]}",
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
