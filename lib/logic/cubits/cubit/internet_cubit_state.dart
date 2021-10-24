part of 'internet_cubit_cubit.dart';

abstract class InternetCubitState extends Equatable {
  const InternetCubitState();

  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetCubitState {}

class Internetconnected extends InternetCubitState {}

class InternetDisconnected extends InternetCubitState {}
