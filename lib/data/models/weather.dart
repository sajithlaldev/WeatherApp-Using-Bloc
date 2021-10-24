class Weather {
  double temp = 0;
  String city = "";
  Weather({this.temp = 0, this.city = ""});
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(temp: json['main']['temp'] - 273.15, city: json['name']);
  }
}
