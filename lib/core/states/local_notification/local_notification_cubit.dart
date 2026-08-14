import 'package:equatable/equatable.dart';

import '../../base/base_cubit.dart';
import '../../services/local_notification/local_notification_service.dart';

part 'local_notification_state.dart';

class LocalNotificationCubit extends BaseCubit<LocalNotificationState> {
  final LocalNotificationService service;

  LocalNotificationCubit({required this.service})
    : super(const LocalNotificationState());

  Future<void> testNotification() async {
    if (state.isLoading) return;

    safeEmit(
      const LocalNotificationState(status: LocalNotificationStatus.loading),
    );

    try {
      final permissionGranted = await service.requestPermission();

      if (!permissionGranted) {
        safeEmit(
          const LocalNotificationState(
            status: LocalNotificationStatus.failure,
            message: 'Notification permission was denied',
          ),
        );
        return;
      }

      await service.show(
        title: 'Test Notification',
        body: 'Local notification berhasil dijalankan 🎉',
        payloadData: {
          'action': 'SELF',
          'screen': 'account',
          'data': {'source': 'test'},
        },
      );

      safeEmit(
        const LocalNotificationState(
          status: LocalNotificationStatus.success,
          message: 'Local notification berhasil dikirim',
        ),
      );
    } catch (e) {
      safeEmit(
        LocalNotificationState(
          status: LocalNotificationStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  Future<void> testNotificationWithImage() async {
    if (state.isLoading) return;

    safeEmit(
      const LocalNotificationState(status: LocalNotificationStatus.loading),
    );

    try {
      final permissionGranted = await service.requestPermission();

      if (!permissionGranted) {
        safeEmit(
          const LocalNotificationState(
            status: LocalNotificationStatus.failure,
            message: 'Notification permission was denied',
          ),
        );
        return;
      }

      await service.showWithImage(
        title: 'Promo Notification',
        body: 'Ini contoh local notification dengan image.',
        imageUrl:
            'https://img.magnific.com/vektor-gratis/stiker-kode-voucher-promo-untuk-belanja-online_1017-61809.jpg',
        payloadData: {
          'action': 'SELF',
          'screen': 'account',
          'data': {'source': 'test_image'},
        },
      );

      safeEmit(
        const LocalNotificationState(
          status: LocalNotificationStatus.success,
          message: 'Notification dengan image berhasil dikirim',
        ),
      );
    } catch (e) {
      safeEmit(
        LocalNotificationState(
          status: LocalNotificationStatus.failure,
          message: e.toString(),
        ),
      );
    }
  }

  void reset() {
    safeEmit(const LocalNotificationState());
  }
}
