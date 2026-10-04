import 'package:equatable/equatable.dart';

import '../../base/base_cubit.dart';
import '../../models/safe_device/safe_device_model.dart';
import '../../services/safe_device/safe_device_service.dart';

part 'security_state.dart';

class SecurityCubit extends BaseCubit<SecurityState> {
  final SafeDeviceService service;

  SecurityCubit({required this.service}) : super(const SecurityState());

  Future<void> check() async {
    safeEmit(state.copyWith(status: SecurityStatus.loading));

    try {
      final result = await service.check();
      final status = _evaluateSecurityStatus(result);

      safeEmit(state.copyWith(status: status, result: result));
    } catch (e) {
      safeEmit(
        state.copyWith(status: SecurityStatus.failure, message: e.toString()),
      );
    }
  }

  SecurityStatus _evaluateSecurityStatus(SafeDeviceModel result) {
    if (result.isJailBroken || result.isJailBrokenCustom) {
      return SecurityStatus.isJailBroken;
    }
    if (!result.isRealDevice) {
      return SecurityStatus.isEmulator;
    }
    if (result.isMockLocation) {
      return SecurityStatus.isMockLocation;
    }
    if (result.isDevelopmentModeEnable) {
      return SecurityStatus.isDevMode;
    }
    if (!result.isSafeDevice) {
      return SecurityStatus.untrusted;
    }
    return SecurityStatus.success;
  }
}
