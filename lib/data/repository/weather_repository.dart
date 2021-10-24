import 'dart:convert';

import 'package:weather_app/data/api/api.dart';
import 'package:weather_app/data/models/weather.dart';

class WeatherRepository {
  //getting the weather data of particular city and the api is defined in Api Service
  Future<Weather> getWeather(String city) async {
    var weatherJson = jsonDecode(await Api().getWeather(city));

    try {
      var weather = Weather.fromJson(weatherJson);
      return weather;
    } catch (e) {
      print(e);
      return Weather();
    }
  }
}
