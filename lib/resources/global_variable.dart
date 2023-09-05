import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/resources/weather.dart';

String apiKey = "85a179f45f67aedc589a5d756daf7d92";

WeatherFactory weatherFactory =
    WeatherFactory("22f1e332aeeabd1c9c2a9e015b83bc61");

ValueNotifier<WeatherInfo> cityData = ValueNotifier(WeatherInfo(
  dateTime: DateTime.now(),
  sunrise: DateTime.now(),
  sunset: DateTime.now(),
));

ValueNotifier<String> cityName = ValueNotifier("Indore");
ValueNotifier<double> longitude = ValueNotifier(75.8682);
ValueNotifier<double> latitude = ValueNotifier(22.720362);

final weatherSVG = <String, String>{
  "000": "lib/assets/satellite.svg",
  "01d": "lib/assets/clear_day.svg",
  "01n": "lib/assets/clear_night.svg",
  "02d": "lib/assets/partly_cloudy_day.svg",
  "02n": "lib/assets/partly_cloudy_night.svg",
  "03d": "lib/assets/cloud.svg",
  "03n": "lib/assets/cloud.svg",
  "04d": "lib/assets/foggy.svg",
  "04n": "lib/assets/foggy.svg",
  "09d": "lib/assets/shower_rain.svg",
  "09n": "lib/assets/shower_rain.svg",
  "10d": "lib/assets/rainy.svg",
  "10n": "lib/assets/rainy.svg",
  "11d": "lib/assets/thunderstorm.svg",
  "11n": "lib/assets/thunderstorm.svg",
  "13d": "lib/assets/snow.svg",
  "13n": "lib/assets/snow.svg",
  "50d": "lib/assets/mist.svg",
  "50n": "lib/assets/mist.svg",
};
