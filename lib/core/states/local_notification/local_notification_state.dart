part of 'local_notification_cubit.dart';

enum LocalNotificationStatus { initial, loading, success, failure }

class LocalNotificationState extends Equatable {
  final LocalNotificationStatus status;
  final String? message;

  const LocalNotificationState({
    this.status = LocalNotificationStatus.initial,
    this.message,
  });

  bool get isLoading => status == LocalNotificationStatus.loading;

  bool get isSuccess => status == LocalNotificationStatus.success;

  bool get isFailure => status == LocalNotificationStatus.failure;

  LocalNotificationState copyWith({
    LocalNotificationStatus? status,
    String? message,
  }) {
    return LocalNotificationState(
      status: status ?? this.status,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, message];
}
