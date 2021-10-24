import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/repository/weather_repository.dart';

//defining weather events
class WeatherEvent extends Equatable {
  //this override is defautl in equatable
  @override
  List<Object?> get props => [];
}

class FetchWeather extends WeatherEvent {
  //this is the event to fetch weather and we should pass city name for fetching the waether data

  String city = "";

  String get getCity => this.city;

  FetchWeather(this.city);

  @override
  List<Object?> get props => [city];
}

class ResetWeather extends WeatherEvent {

}

//defining weather states
class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}


//this will be the initial state

class WeatherIsNotSearched extends WeatherState {}

//loading state when the async task is running
class WeatherLoading extends WeatherState {}

//state when the api is finished executing and got the weather data
class WeatherIsLoaded extends WeatherState {
  //need to define weather model because this state should contain the weather data
  Weather weather;
  WeatherIsLoaded({required this.weather});

  @override
  // TODO: implement props
  List<Object?> get props => [weather];
}

//state when any error occurs
class WeatherError extends WeatherState {}

//defining weather bloc
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  //on the constractor we should pass the repository and initial state will be WeatherIsNotSearched
  WeatherBloc(this.weatherRepository) : super(WeatherIsNotSearched()) {
    on<FetchWeather>(_weatherFetchRequested);
    on<ResetWeather>((ResetWeather event, Emitter<WeatherState> emit) =>
        emit(WeatherIsNotSearched()));
  }

  WeatherRepository weatherRepository;

  //function that will be executed when FeatherEvent is triggered
  _weatherFetchRequested(FetchWeather event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      //reading the whether data using the repository I have created
      final weather = await weatherRepository.getWeather(event.city);
      emit(WeatherIsLoaded(weather: weather));
    } catch (_) {
      emit(WeatherError());
    }
  }
}
