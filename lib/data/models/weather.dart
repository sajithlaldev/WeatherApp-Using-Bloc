class Weather {
  int temp = 0;
  String city = "";
  Weather({this.temp = 0, this.city = ""});
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(temp: json['main']['temp'], city: json['name']);
  }
}
