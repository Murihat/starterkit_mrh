part of 'security_cubit.dart';

enum SecurityStatus {
  initial,
  loading,
  isMockLocation,
  isJailBroken,
  isEmulator,
  isDevMode,
  untrusted,
  failure,
  success,
}

class SecurityState extends Equatable {
  final SecurityStatus status;
  final SafeDeviceModel? result;
  final String? message;

  const SecurityState({
    this.status = SecurityStatus.initial,
    this.result,
    this.message,
  });

  SecurityState copyWith({
    SecurityStatus? status,
    SafeDeviceModel? result,
    String? message,
  }) {
    return SecurityState(
      status: status ?? this.status,
      result: result ?? this.result,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [status, result, message];
}
