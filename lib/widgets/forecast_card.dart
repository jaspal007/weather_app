import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_app/resources/global_variable.dart';
import 'package:weather_app/resources/weather.dart';

class MyForecastCard extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final double elevation;
  final WeatherInfo weatherInfo;

  const MyForecastCard({
    super.key,
    required this.width,
    required this.height,
    this.radius = 10.0,
    this.elevation = 5,
    required this.weatherInfo,
  });

  @override
  State<MyForecastCard> createState() => _MyForecastCardState();
}

class _MyForecastCardState extends State<MyForecastCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black87,
      elevation: widget.elevation,
      color: Colors.purple.shade100,
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.circular(
          widget.radius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: widget.height,
          width: widget.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: widget.height * 0.1,
                width: widget.width,
                child: SvgPicture.asset(
                  (widget.weatherInfo.weatherIcon == "---")
                      ? weatherSVG["000"]!
                      : weatherSVG[widget.weatherInfo.weatherIcon]!,
                ),
              ),
              Text(
                widget.weatherInfo.weatherDescription,
              ),
              const Divider(
                thickness: 1,
                color: Colors.black45,
              ),
              Text(
                "Max: ${(widget.weatherInfo.tempMax == double.infinity) ? "--" : widget.weatherInfo.tempMax.round()}℃",
              ),
              Text(
                "Min: ${(widget.weatherInfo.tempMin == double.infinity) ? "--" : widget.weatherInfo.tempMin.round()}℃",
              ),
              Text(
                "Humidity: ${(widget.weatherInfo.humidity == 9999) ? "---" : widget.weatherInfo.humidity} RH",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
