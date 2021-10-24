import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

part 'internet_cubit_state.dart';

class InternetCubitCubit extends Cubit<InternetCubitState> {
  late StreamSubscription internetSubscription;
  InternetCubitCubit() : super(InternetLoading()) {
    montiorConnectivity();
  }

  void emitInternetConnected() => emit(Internetconnected());

  void emitInternetDIsconnected() => emit(InternetDisconnected());

  void emitInternetLoading() => emit(InternetLoading());

  montiorConnectivity() async {
    if ((await Connectivity().checkConnectivity()) == ConnectivityResult.none) {
      emitInternetDIsconnected();
    }
    internetSubscription = Connectivity().onConnectivityChanged.listen((event) {
      if (event == ConnectivityResult.none) {
        emitInternetDIsconnected();
      } else if (event == ConnectivityResult.mobile ||
          event == ConnectivityResult.wifi) {
        emitInternetConnected();
      } else {
        print('Montoring');
        emitInternetLoading();
      }
    });
  }

  @override
  Future<void> close() {
    // TODO: implement close
    internetSubscription.cancel();
    return super.close();
  }
}
