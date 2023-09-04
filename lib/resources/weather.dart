class WeatherInfo {
  String place;
  double latitude;
  double longitude;
  double temperature;
  double tempMin;
  double tempMax;
  double tempFeels;
  DateTime dateTime = DateTime.now();
  String weather;
  String precipitation;
  double humidity;
  double pressure;
  DateTime sunrise;
  DateTime sunset;
  double windSpeed;
  double windDirection;
  String weatherIcon;
  WeatherInfo({
    required this.dateTime,
    this.temperature = double.infinity,
    this.tempMin = double.infinity,
    this.tempMax = double.infinity,
    this.tempFeels = double.infinity,
    this.weather = "---",
    this.weatherIcon = "---",
    this.place = "---",
    this.humidity = double.infinity,
    this.latitude = double.infinity,
    this.longitude = double.infinity,
    this.precipitation = "---",
    required this.sunrise,
    required this.sunset,
    this.pressure = double.infinity,
    this.windDirection = double.infinity,
    this.windSpeed = double.infinity,
  });
}
