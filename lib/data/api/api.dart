import 'package:http/http.dart' as http;

class Api {
  Future<String> getWeather(String city) async {
    print(city);

    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=939f1bb9804f2b0f2c23a439b2d2fa89');
    var res = await http.get(url);
    return res.body;
  }
}
