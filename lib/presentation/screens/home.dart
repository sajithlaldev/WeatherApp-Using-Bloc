import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/logic/blocs/weather_bloc.dart';
import 'package:weather_app/logic/cubits/cubit/internet_cubit_cubit.dart';

class HomeScreen extends StatelessWidget {
  final _cityController = TextEditingController();

  bool isInternetAvailable = false;

  @override
  Widget build(BuildContext context) {
    final height =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height;
    final width = MediaQuery.of(context).size.width;
    final weatherRepository = WeatherRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Today'),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (_) => WeatherBloc(weatherRepository),
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<InternetCubitCubit, InternetCubitState>(
                builder: (context, state) {
                  if (state is Internetconnected) {
                    return Container();
                  } else if (state is InternetDisconnected) {
                    return Container(
                      width: width,
                      height: height * 0.04,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          'Network not available',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  } else {
                    return LinearProgressIndicator();
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 250,
                  width: width,
                  child: RiveAnimation.asset(
                    'assets/cloud.riv',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherIsNotSearched) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8.0, right: 12, left: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: TextField(
                                controller: _cityController,
                                decoration: InputDecoration(
                                    fillColor: Colors.grey.shade100,
                                    filled: true,
                                    isDense: true,
                                    labelText: 'Enter City',
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        BlocBuilder<InternetCubitCubit, InternetCubitState>(
                          builder: (context, state) {
                            var c = false;
                            if (state is Internetconnected) {
                              c = true;
                            } else {
                              c = false;
                            }

                            return SizedBox(
                              width: width - 20,
                              height: 40,
                              child: RaisedButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: c
                                    ? () {
                                        //adding Fetch Weather Event
                                        if (_cityController.text.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Enter city name!')));
                                        } else {
                                          BlocProvider.of<WeatherBloc>(context)
                                              .add(FetchWeather(
                                                  _cityController.text));
                                        }
                                      }
                                    : null,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Get Weather',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Center(
                      child: Text('Internal Server Error'),
                    );
                  } else if (state is WeatherLoading) {
                    return Center(
                      child: SizedBox(
                          height: 150,
                          child:
                              RiveAnimation.asset('assets/finger_tapping.riv')),
                    );
                  } else if (state is WeatherCityNotFound) {
                    return Center(
                      child: Column(
                        children: [
                          Text('Weather in ${state.getCity} not available'),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width - 20,
                            height: 40,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                //adding Fetch Weather Event
                                BlocProvider.of<WeatherBloc>(context)
                                    .add(ResetWeather());
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Retry',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    Weather weather = (state as WeatherIsLoaded).weather;
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            '${weather.temp.toStringAsFixed(2)} C',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('${weather.city}'),
                          SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: width - 20,
                            height: 40,
                            child: RaisedButton(
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                //adding Fetch Weather Event
                                BlocProvider.of<WeatherBloc>(context)
                                    .add(ResetWeather());
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                'Go Back',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
