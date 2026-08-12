import 'package:equatable/equatable.dart';

import '../../../../base/base_cubit.dart';
import '../../../../models/safe_device/safe_device_model.dart';
import '../../../../services/safe_device/safe_device_service.dart';

part 'security_state.dart';

class SecurityCubit extends BaseCubit<SecurityState> {
  final SafeDeviceService service;

  SecurityCubit({required this.service}) : super(const SecurityState());

  Future<void> check() async {
    safeEmit(state.copyWith(status: SecurityStatus.loading));

    final result = await service.check();

    print("================ SAFE DEVICE check");
    print(result.toJson());

    safeEmit(
      state.copyWith(
        status: result.isMockLocation
            ? SecurityStatus.isMockLocation
            : SecurityStatus.success,
        result: result,
      ),
    );
  }
}
