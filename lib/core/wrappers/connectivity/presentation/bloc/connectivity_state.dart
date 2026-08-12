part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  final bool isOnline;
  const ConnectivityState(this.isOnline);

  factory ConnectivityState.initial() => const ConnectivityState(true);

  @override
  List<Object?> get props => [isOnline];
}
