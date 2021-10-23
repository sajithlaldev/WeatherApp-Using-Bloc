import 'package:http/http.dart' as http;

class Api {
  var client;
  Api() {
    this.client = http.Client();
  }

  Future<String> getWeather(String city) async {
    return await client.get(
        'https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=939f1bb9804f2b0f2c23a439b2d2fa89');
  }
}
