import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart';
import 'package:weather_app/data/models/weather.dart';
import 'package:weather_app/data/repository/weather_repository.dart';
import 'package:weather_app/logic/blocs/weather_bloc.dart';

class HomeScreen extends StatelessWidget {
  final _cityController = TextEditingController();
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
      body: BlocProvider(
        create: (_) => WeatherBloc(weatherRepository),
        child: Container(
          height: height,
          width: width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 300,
                  width: width,
                  child: RiveAnimation.asset(
                    'assets/cloud.riv',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BlocConsumer<WeatherBloc, WeatherState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is WeatherIsNotSearched) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _cityController,
                            decoration: InputDecoration(
                                isDense: true,
                                labelText: 'Enter City',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: width - 20,
                          height: 40,
                          child: RaisedButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              //adding Fetch Weather Event
                              if (_cityController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text('Enter city name!')));
                              } else {
                                BlocProvider.of<WeatherBloc>(context)
                                    .add(FetchWeather(_cityController.text));
                              }
                            },
                            child: Text(
                              'Get Weather',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Center(
                      child: Text('Internal Server Error'),
                    );
                  } else if (state is WeatherLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
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
                                fontWeight: FontWeight.bold, fontSize: 26),
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
