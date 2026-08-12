import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/logger/logger_service.dart';

class AppObserver extends BlocObserver {
  final LoggerService logger;

  AppObserver({required this.logger}) : super();

  @override
  void onCreate(BlocBase bloc) {
    // logger.d('BLOC_CREATE', bloc.runtimeType.toString());
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    // logger.d('BLOC_EVENT', '${bloc.runtimeType} → ${_pretty(event)}');
    debugPrint('EVENT: ${bloc.runtimeType} -> $event');
    debugPrintStack(maxFrames: 8);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    // logger.d('BLOC_CHANGE', '''
    // ${bloc.runtimeType}
    // CURRENT: ${_pretty(change.currentState)}
    // NEXT   : ${_pretty(change.nextState)}
    // ''');
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // logger.d('BLOC_TRANSITION', '''
    // ${bloc.runtimeType}
    // EVENT  : ${_pretty(transition.event)}
    // CURRENT: ${_pretty(transition.currentState)}
    // NEXT   : ${_pretty(transition.nextState)}
    // ''');
    super.onTransition(bloc, transition);
  }

  @override
  void onClose(BlocBase bloc) {
    // logger.d('BLOC_CLOSE', bloc.runtimeType.toString());
    super.onClose(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    logger.e('BLOC_ERROR', bloc.runtimeType.toString(), error, stackTrace);
    super.onError(bloc, error, stackTrace);
  }

  // String _pretty(Object? object) {
  //   if (object == null) return 'null';

  //   final type = object.runtimeType;

  //   try {
  //     final props = (object as dynamic).props;
  //     return '$type(${props.join(', ')})';
  //   } catch (_) {
  //     return object.toString();
  //   }
  // }
}
