import 'dart:convert';

import 'package:weather_app/data/api/api.dart';
import 'package:weather_app/data/models/weather.dart';

class WeatherRepository {
  Future<Weather> getWeather(String city) async {
    var weatherJson = jsonDecode(await Api().getWeather(city));
    return Weather(
        city: weatherJson['name'], temp: weatherJson['main']['temp[']);
  }
}
