import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/resources/global_variable.dart';
import 'package:weather_app/resources/weather.dart';
import 'package:weather_app/screens/bottom_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  bool isLoading = false;
  String temperature = "--";
  String tempMin = "--";
  String tempMax = "--";
  String icon = weatherSVG["000"]!;
  WeatherInfo info = WeatherInfo(
    dateTime: DateTime.now(),
    sunrise: DateTime.now(),
    sunset: DateTime.now(),
  );
  Future<void> callWeather() async {
    setState(() {
      isLoading = true;
    });
    try {
      Weather weatherInfo =
          await weatherFactory.currentWeatherByCityName("Seattle");
      print(weatherInfo);
      setState(() {
        info.dateTime = weatherInfo.date!;
        info.temperature = weatherInfo.temperature!.celsius!;
        info.weather = weatherInfo.weatherDescription!;
        info.place = "${weatherInfo.areaName!}, ${weatherInfo.country!}";
        info.weatherIcon = weatherInfo.weatherIcon!;
        info.tempMin = weatherInfo.tempMin!.celsius!;
        info.tempMax = weatherInfo.tempMax!.celsius!;
        temperature = info.temperature.round().toString();
        icon = weatherSVG[info.weatherIcon]!;
        isLoading = false;
      });
      print("weather icon: ${info.weatherIcon}");
    } on OpenWeatherAPIException catch (error) {
      // print((error.toString()));
      SnackBar snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    super.initState();
    callWeather();
  }

  @override
  Widget build(BuildContext context) {
    bool showDragHandle(value) {
      bool flag = true;
      setState(() {
        if (value == Orientation.landscape) flag = false;
      });
      return flag;
    }

    final orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width - 25;
    print("height: ${MediaQuery.of(context).size.height}"); //852
    print("width: ${MediaQuery.of(context).size.width}"); //393

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   title: const Text("Current location"),
      // ),
      drawer: Drawer(
        width:
            (orientation == Orientation.portrait) ? width * 0.6 : width * 0.4,
        backgroundColor: ThemeData.dark().cardColor,
      ),
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: (orientation == Orientation.portrait)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.blue,
                    height: height * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                temperature,
                                style: const TextStyle(
                                  fontSize: 80,
                                  // backgroundColor: Colors.green,
                                ),
                              ),
                              const Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 15),
                                  ),
                                  Text(
                                    "℃",
                                    style: TextStyle(
                                      fontSize: 30,
                                      // backgroundColor: Colors.yellow,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          info.place,
                        ),
                        Container(
                          // color: Colors.red,
                          height: height * 0.06,
                          width: double.infinity,
                          child: SvgPicture.asset(icon),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        Text(
                          info.weather,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Get Weather",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.teal,
                    height: height * 0.65,
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  child: SizedBox(
                                    height: 100,
                                    width: width / 2,
                                    child: const Center(child: Text("card1")),
                                  ),
                                ),
                                Card(
                                  child: SizedBox(
                                    height: 100,
                                    width: width / 2,
                                    child: const Center(child: Text("card2")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Card(
                            child: SizedBox(
                              height: 400,
                              width: double.infinity,
                              child: Center(child: Text("card4")),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  child: SizedBox(
                                    height: 100,
                                    width: width / 2,
                                    child: const Center(child: Text("card5")),
                                  ),
                                ),
                                Card(
                                  child: SizedBox(
                                    height: 100,
                                    width: width / 2,
                                    child: const Center(child: Text("card6")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  child: SizedBox(
                                    height: 100,
                                    width: width / 2,
                                    child: const Center(child: Text("card3")),
                                  ),
                                ),
                                Card(
                                  child: SizedBox(
                                    height: 100,
                                    width: width / 2,
                                    child: const Center(child: Text("card7")),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            : SizedBox(
                child: Row(
                  children: [
                    Container(
                      color: Colors.blue,
                      height: height,
                      width: width / 3.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "71",
                                  style: TextStyle(
                                    fontSize: 100,
                                    // backgroundColor: Colors.green,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 15),
                                    ),
                                    Text(
                                      "℃",
                                      style: TextStyle(
                                        fontSize: 40,
                                        // backgroundColor: Colors.yellow,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(20),
                          ),
                          SizedBox(
                            height: height * 0.3,
                            width: double.infinity,
                            child: SvgPicture.asset(
                              "lib/assets/foggy.svg",
                              fit: BoxFit.contain,
                              color: Colors.white,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          const Text(
                            "Foggy",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.teal,
                      height: height,
                      width: (2.3 * width / 3.25),
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Card(
                                      child: SizedBox(
                                        height: 100,
                                        width: (2 * width / 3) / 3,
                                        child:
                                            const Center(child: Text("card1")),
                                      ),
                                    ),
                                    Card(
                                      child: SizedBox(
                                        height: 100,
                                        width: (2 * width / 3) / 3,
                                        child:
                                            const Center(child: Text("card2")),
                                      ),
                                    ),
                                    Card(
                                      child: SizedBox(
                                        height: 100,
                                        width: (2 * width / 3) / 3,
                                        child:
                                            const Center(child: Text("card3")),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Card(
                                child: SizedBox(
                                  height: 400,
                                  width: double.infinity,
                                  child: Center(child: Text("card4")),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Card(
                                      child: SizedBox(
                                        height: 100,
                                        width: (2 * width / 3) / 3,
                                        child:
                                            const Center(child: Text("card5")),
                                      ),
                                    ),
                                    Card(
                                      child: SizedBox(
                                        height: 100,
                                        width: (2 * width / 3) / 3,
                                        child:
                                            const Center(child: Text("card6")),
                                      ),
                                    ),
                                    Card(
                                      child: SizedBox(
                                        height: 100,
                                        width: (2 * width / 3) / 3,
                                        child:
                                            const Center(child: Text("card7")),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: (orientation == Orientation.landscape)
          ? FloatingActionButtonLocation.miniEndDocked
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: (orientation == Orientation.portrait)
          ? FloatingActionButton.extended(
              backgroundColor: ThemeData.dark().primaryColor,
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    showDragHandle: true,
                    isDismissible: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => const MyBottomSheet());
              },
              label: const Text(
                "Add City",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              icon: const Icon(Icons.add),
            )
          : FloatingActionButton(
              backgroundColor: ThemeData.dark().primaryColor,
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    showDragHandle: showDragHandle(orientation),
                    isDismissible: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    context: context,
                    builder: (context) => const MyBottomSheet());
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
