import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/resources/global_variable.dart';
import 'package:weather_app/resources/location.dart';
import 'package:weather_app/resources/weather.dart';
import 'package:weather_app/screens/bottom_screen.dart';
import 'package:weather_app/widgets/card.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/widgets/forecast_card.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String temperature = "--";
  String tempMin = "--";
  String tempMax = "--";
  String icon = weatherSVG["000"]!;
  WeatherInfo info = WeatherInfo();

  Future<void> getLocation() async {
    try {
      locationData = await location.getLocation();
      setState(() {
        longitude.value = locationData.longitude!;
        latitude.value = locationData.latitude!;
      });
      print("long: ${longitude.value}\n lat: ${latitude.value}");
    } on Exception catch (error) {
      print(error.toString());
    }
    getForecast();
    callWeather();
  }

  Future<void> getCity() async {
    var url = Uri.parse(
        "http://api.openweathermap.org/geo/1.0/reverse?lat=${latitude.value}&lon=${longitude.value}&limit=5&appid=$apiKey");
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        List city = jsonDecode(data);
        setState(() {
          info.place = "${city.first["name"]}, ${city.first["country"]}";
        });
      }
    } on Exception catch (error) {
      print(error);
    }
  }

  Future<void> callWeather() async {
    getCity();
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=${latitude.value}&lon=${longitude.value}&appid=$apiKey");
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        Map weatherData = jsonDecode(data);
        print(weatherData["main"]);
        setState(() {
          if (weatherData.isNotEmpty) {
            info.temperature = weatherData["main"]["temp"] - 273.15;
            info.weatherDescription = weatherData["weather"][0]["description"];
            info.weatherIcon = weatherData["weather"][0]["icon"];
            info.tempMin = weatherData["main"]["temp_min"] - 273.15;
            info.tempFeels = weatherData["main"]["feels_like"] - 273.15;
            info.tempMax = weatherData["main"]["temp_max"] - 273.15;
            info.sunrise = weatherData["sys"]["sunrise"];
            info.sunset = weatherData["sys"]["sunset"];
            info.windSpeed = weatherData["wind"]["speed"].toString();
            info.windDirection = weatherData["wind"]["deg"] ?? 0;
            info.windGust = weatherData["wind"]["gust"] ?? 0;
            info.visibility = weatherData["visibility"] ?? 0;
            info.pressure = weatherData["main"]["pressure"] ?? 0;
            info.humidity = weatherData["main"]["humidity"] ?? 0;
            info.seaLevel = weatherData["main"]["sea_level"] ?? 9999;
            info.groundLevel = weatherData["main"]["grnd_level"] ?? 9999;
          }
        });
      }
    } on Exception catch (error) {
      print(error.runtimeType);
      SnackBar snackBar = SnackBar(content: Text(error.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> getForecast() async {
    var url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=${latitude.value}&lon=${longitude.value}&appid=$apiKey");
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        Map forecast = jsonDecode(data);
        List weather = forecast["list"];
        for (int i = 0; i < 5; i++) {
          var data = weather[i];
          setState(() {
            weatherForecast[i] = WeatherInfo(
              tempMin: data["main"]["temp_min"] - 273.15,
              tempMax: data["main"]["temp_max"] - 273.15,
              humidity: data["main"]["humidity"] ?? 9999,
              weatherDescription: data["weather"][0]["description"],
              weatherIcon: data["weather"][0]["icon"],
            );
          });
        }
      }
      print("forecast");
    } on Exception catch (error) {
      print(error);
    }
  }

  bool showDragHandle(value) {
    bool flag = true;
    setState(() {
      if (value == Orientation.landscape) flag = false;
    });
    return flag;
  }

  Future getmodalBottomSheet(orientation) {
    return showModalBottomSheet(
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
  }

  @override
  void initState() {
    super.initState();
    locationService(getLocation());
    latitude.addListener(() {
      callWeather();
      getForecast();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    double height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewPadding.top;
    double width = MediaQuery.of(context).size.width - 25;
    print("height: ${MediaQuery.of(context).size.height}"); //852
    print("width: ${MediaQuery.of(context).size.width}"); //393

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        actions: [
          IconButton(
            onPressed: () {
              getmodalBottomSheet(orientation);
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white70,
            ),
            splashRadius: 15,
          ),
        ],
        backgroundColor: Colors.purple.shade900,
      ),
      body: SafeArea(
        bottom: false,
        left: false,
        right: false,
        child: (orientation == Orientation.portrait)
            ? AnimatedContainer(
                duration: const Duration(seconds: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.shade900,
                      Colors.purple.shade800,
                      Colors.purple.shade700,
                      Colors.purple.shade600,
                      Colors.purple.shade500,
                      Colors.purple.shade300,
                      Colors.purple.shade200,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 5),
                      // decoration: BoxDecoration(),
                      // color: Colors.grey,
                      height: height * 0.43,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (info.temperature == double.infinity)
                                      ? "--"
                                      : "${info.temperature.round()}",
                                  style: TextStyle(
                                    fontSize: height * 0.1,
                                    color: Colors.white70,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 15),
                                    ),
                                    Text(
                                      "℃",
                                      style: TextStyle(
                                        fontSize: height * 0.05,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(height * 0.35 * 0.05),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            info.place.toUpperCase(),
                            style: TextStyle(
                              fontSize: height * 0.03,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(
                            // color: Colors.red,
                            height: height * 0.1,
                            width: double.infinity,
                            child: SvgPicture.asset(
                              (info.weatherIcon == "---")
                                  ? icon
                                  : weatherSVG[info.weatherIcon]!,
                              color: Colors.white70,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Text(
                            info.weatherDescription.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.35 * 0.06,
                              color: Colors.white70,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              print("tapped");
                              locationService(getLocation());
                            },
                            child: const Text(
                              "Get current weather",
                              style: TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.teal,
                      height: height * 0.5,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  MyCard(
                                    width: width / 2,
                                    height: 100,
                                    radius: 20,
                                    widget: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            (info.tempMin == double.infinity)
                                                ? "--℃"
                                                : "Min: ${info.tempMin.round()}℃",
                                          ),
                                          Text(
                                            (info.tempMax == double.infinity)
                                                ? "--℃"
                                                : "Max: ${info.tempMax.round()}℃",
                                          ),
                                          Text(
                                            (info.tempFeels == double.infinity)
                                                ? "--℃"
                                                : "Feels like: ${info.tempFeels.round()}℃",
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  MyCard(
                                    width: width / 2,
                                    height: 100,
                                    radius: 20,
                                    widget: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.sunny,
                                            ),
                                            Text(
                                              "Sunrise: ${DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(info.sunrise * 1000))}",
                                              //"Sunrise: ${info.sunrise.hour}:${info.sunrise.minute}",
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Icon(
                                              Icons.sunny_snowing,
                                            ),
                                            Text(
                                              "Sunset: ${DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(info.sunset * 1000))}",
                                              // "Sunset: ${info.sunset.hour}:${info.sunset.minute}",
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                  ),
                                ],
                              ),
                            ),
                            MyCard(
                              width: width,
                              height: 400,
                              radius: 20,
                              widget: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 5.0,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ...weatherForecast.map(
                                        (value) => MyForecastCard(
                                          width: width / 3,
                                          height: 405,
                                          radius: 10,
                                          elevation: 5,
                                          weatherInfo: value,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  MyCard(
                                    width: width / 2,
                                    height: 100,
                                    radius: 20,
                                    widget: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            (info.windSpeed == 9999)
                                                ? "Wind Speed: -- kmph"
                                                : "Wind Speed: ${info.windSpeed} mps",
                                          ),
                                          Text(
                                            (info.windDirection ==
                                                    double.infinity)
                                                ? "Direction: --°"
                                                : "Direction: ${info.windDirection}°",
                                          ),
                                          Text(
                                            ((info.windGust == double.infinity)
                                                ? "Gust: -- kmph"
                                                : "Gust: ${((info.windGust * 18) / 5).round()} kmph"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  MyCard(
                                    width: width / 2,
                                    height: 100,
                                    radius: 20,
                                    widget: Center(
                                      child: Text(
                                        "Visibility: ${info.visibility / 1000} km",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  MyCard(
                                    width: width / 2,
                                    height: 100,
                                    radius: 20,
                                    widget: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Pressure: ${info.pressure} pa",
                                        ),
                                        Text(
                                          "Humidity: ${info.humidity} RH",
                                        ),
                                      ],
                                    )),
                                  ),
                                  MyCard(
                                    width: width / 2,
                                    height: 100,
                                    radius: 20,
                                    widget: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          (info.groundLevel == 9999)
                                              ? "Ground Level: -- m"
                                              : "Ground Level: ${info.groundLevel} m",
                                        ),
                                        Text(
                                          (info.seaLevel == 9999)
                                              ? "Sea Level: -- m"
                                              : "Sea Level: ${info.seaLevel} m",
                                        ),
                                      ],
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            : AnimatedContainer(
                duration: const Duration(seconds: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.shade900,
                      Colors.purple.shade800,
                      Colors.purple.shade700,
                      Colors.purple.shade600,
                      Colors.purple.shade500,
                      Colors.purple.shade300,
                      Colors.purple.shade200,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(seconds: 5),
                      // decoration: BoxDecoration(),
                      // color: Colors.grey,
                      height: height,
                      width: width / 3.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  (info.temperature == double.infinity)
                                      ? "--"
                                      : "${info.temperature.round()}",
                                  style: TextStyle(
                                    fontSize: height * 0.2,
                                    color: Colors.white70,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 7.5),
                                    ),
                                    Text(
                                      "℃",
                                      style: TextStyle(
                                        fontSize: height * 0.1,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(height * 0.35 * 0.05),
                          ),
                          Text(
                            textAlign: TextAlign.center,
                            info.place.toUpperCase(),
                            style: TextStyle(
                              fontSize: height * 0.06,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(
                            // color: Colors.red,
                            height: height * 0.2,
                            width: double.infinity,
                            child: SvgPicture.asset(
                              (info.weatherIcon == "---")
                                  ? icon
                                  : weatherSVG[info.weatherIcon]!,
                              color: Colors.white70,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Text(
                            info.weatherDescription.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: height * 0.7 * 0.06,
                              color: Colors.white70,
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(
                                Colors.purple.shade700,
                              ),
                              foregroundColor: const MaterialStatePropertyAll(
                                Colors.white70,
                              ),
                            ),
                            onPressed: () {
                              print("tapped");
                              locationService(getLocation());
                            },
                            child: const Text(
                              "Get current weather",
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // color: Colors.teal,
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
                                    MyCard(
                                      width: (2 * width / 3) / 3,
                                      height: 100,
                                      radius: 20,
                                      widget: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              (info.tempMin == double.infinity)
                                                  ? "--℃"
                                                  : "Min: ${info.tempMin.round()}℃",
                                            ),
                                            Text(
                                              (info.tempMax == double.infinity)
                                                  ? "--℃"
                                                  : "Max: ${info.tempMax.round()}℃",
                                            ),
                                            Text(
                                              (info.tempFeels ==
                                                      double.infinity)
                                                  ? "--℃"
                                                  : "Feels like: ${info.tempFeels.round()}℃",
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    MyCard(
                                      width: (2 * width / 3) / 3,
                                      height: 100,
                                      radius: 20,
                                      widget: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.sunny,
                                                ),
                                                Text(
                                                  "Sunrise: ${DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(info.sunrise * 1000))}",
                                                  //"Sunrise: ${info.sunrise.hour}:${info.sunrise.minute}",
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Icon(
                                                  Icons.sunny_snowing,
                                                ),
                                                Text(
                                                  "Sunset: ${DateFormat('HH:mm a').format(DateTime.fromMillisecondsSinceEpoch(info.sunset * 1000))}",
                                                  // "Sunset: ${info.sunset.hour}:${info.sunset.minute}",
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    MyCard(
                                      width: (2 * width / 3) / 3,
                                      height: 100,
                                      radius: 20,
                                      widget: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              (info.windSpeed == 9999)
                                                  ? "Wind Speed: -- kmph"
                                                  : "Wind Speed: ${info.windSpeed} mps",
                                            ),
                                            Text(
                                              (info.windDirection ==
                                                      double.infinity)
                                                  ? "Direction: --°"
                                                  : "Direction: ${info.windDirection}°",
                                            ),
                                            Text(
                                              ((info.windGust ==
                                                      double.infinity)
                                                  ? "Gust: -- kmph"
                                                  : "Gust: ${((info.windGust * 18) / 5).round()} kmph"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              MyCard(
                                width: (2.3 * width / 3.25),
                                height: 400,
                                radius: 20,
                                widget: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 5.0,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ...weatherForecast.map(
                                          (value) => MyForecastCard(
                                            width: (2.3 * width / 3.25) / 4,
                                            height: 405,
                                            radius: 20,
                                            elevation: 5,
                                            weatherInfo: value,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    MyCard(
                                      width: (2 * width / 3) / 3,
                                      height: 100,
                                      radius: 20,
                                      widget: Center(
                                        child: Text(
                                          "Visibility: ${info.visibility / 1000} km",
                                        ),
                                      ),
                                    ),
                                    MyCard(
                                      width: (2 * width / 3) / 3,
                                      height: 100,
                                      radius: 20,
                                      widget: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Pressure: ${info.pressure} pa",
                                          ),
                                          Text(
                                            "Humidity: ${info.humidity} RH",
                                          ),
                                        ],
                                      )),
                                    ),
                                    MyCard(
                                      width: (2 * width / 3) / 3,
                                      height: 100,
                                      radius: 20,
                                      widget: Center(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            (info.groundLevel == 9999)
                                                ? "Ground Level: -- m"
                                                : "Ground Level: ${info.groundLevel} m",
                                          ),
                                          Text(
                                            (info.seaLevel == 9999)
                                                ? "Sea Level: -- m"
                                                : "Sea Level: ${info.seaLevel} m",
                                          ),
                                        ],
                                      )),
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
    );
  }
}
