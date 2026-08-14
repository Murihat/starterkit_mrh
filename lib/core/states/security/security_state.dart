part of 'security_cubit.dart';

enum SecurityStatus { initial, loading, isMockLocation, success }

class SecurityState extends Equatable {
  final SecurityStatus status;
  final SafeDeviceModel? result;

  const SecurityState({this.status = SecurityStatus.initial, this.result});

  SecurityState copyWith({SecurityStatus? status, SafeDeviceModel? result}) {
    return SecurityState(
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, result];
}
