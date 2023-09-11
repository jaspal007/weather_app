class WeatherInfo {
  String place;
  double latitude;
  double longitude;
  double temperature;
  double tempMin;
  double tempMax;
  double tempFeels;
  int dateTime;
  String weatherDescription;
  String precipitation;
  int humidity;
  int pressure;
  int sunrise;
  int sunset;
  String windSpeed;
  int windDirection;
  double windGust;
  String weatherIcon;
  int visibility;
  int seaLevel;
  int groundLevel;
  WeatherInfo({
    this.dateTime = 9999,
    this.temperature = double.infinity,
    this.tempMin = double.infinity,
    this.tempMax = double.infinity,
    this.tempFeels = double.infinity,
    this.weatherDescription = "---",
    this.weatherIcon = "---",
    this.place = "---",
    this.humidity = 9999,
    this.latitude = double.infinity,
    this.longitude = double.infinity,
    this.precipitation = "---",
    this.sunrise = 9999,
    this.sunset = 9999,
    this.pressure = 9999,
    this.windDirection = 9999,
    this.windSpeed = "---",
    this.windGust = double.infinity,
    this.visibility = 9999,
    this.groundLevel = 9999,
    this.seaLevel = 9999,
  });
}
