part of 'connectivity_bloc.dart';

abstract class ConnectivityEvent {}

class ConnectivityStarted extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final bool isOnline;
  ConnectivityChanged(this.isOnline);
}
