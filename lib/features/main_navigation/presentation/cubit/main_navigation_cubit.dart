import 'package:equatable/equatable.dart';

import '../../../../core/base/base_cubit.dart';

part 'main_navigation_state.dart';

class MainNavigationCubit extends BaseCubit<MainNavigationState> {
  MainNavigationCubit() : super(const MainNavigationState(index: 0));

  void changeIndex(int index) {
    safeEmit(MainNavigationState(index: index));
  }
}
