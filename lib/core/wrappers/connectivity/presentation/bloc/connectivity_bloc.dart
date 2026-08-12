import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../services/connectivity/connectivity_service.dart';
import '../../../../services/logger/logger_service.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityService service;
  final LoggerService logger;

  StreamSubscription<bool>? _sub;
  Timer? _debounceTimer;

  ConnectivityBloc({required this.service, required this.logger})
    : super(ConnectivityState.initial()) {
    on<ConnectivityStarted>(_onStarted);
    on<ConnectivityChanged>(_onChanged);
  }

  void _onStarted(ConnectivityStarted event, Emitter<ConnectivityState> emit) {
    logger.i('CONNECTIVITY', 'Start listening');

    _sub = service.onStatusChanged.listen((isOnline) {
      _debounceTimer?.cancel();
      _debounceTimer = Timer(
        const Duration(milliseconds: 300),
        () => add(ConnectivityChanged(isOnline)),
      );
    });
  }

  void _onChanged(ConnectivityChanged event, Emitter<ConnectivityState> emit) {
    logger.w('CONNECTIVITY', 'Online status changed → ${event.isOnline}');
    emit(ConnectivityState(event.isOnline));
  }

  @override
  Future<void> close() {
    logger.d('CONNECTIVITY', 'Dispose bloc');
    _debounceTimer?.cancel();
    _sub?.cancel();
    return super.close();
  }
}
