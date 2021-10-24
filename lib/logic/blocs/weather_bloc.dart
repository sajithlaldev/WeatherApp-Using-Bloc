import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/repository/weather_repository.dart';

//defining weather events
class WeatherEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {
  String city = "";

  String get getCity => this.city;

  FetchWeather(this.city);

  @override
  // TODO: implement props
  List<Object?> get props => [city];
}

//defining weather states
class WeatherState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class WeatherIsNotSearched extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherIsLoaded extends WeatherState {
  Weather weather;
  WeatherIsLoaded({required this.weather});

  @override
  // TODO: implement props
  List<Object?> get props => [weather];
}

class WeatherError extends WeatherState {}

//define weather bloc

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc(this.weatherRepository) : super(WeatherIsNotSearched()) {
    on<FetchWeather>(_weatherFetchRequested);
  }

  WeatherRepository weatherRepository;

  _weatherFetchRequested(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getWeather(event.city);
      emit(WeatherIsLoaded(weather: weather));
    } catch (_) {
      emit(WeatherError());
    }
  }
}
