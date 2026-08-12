part of 'main_navigation_cubit.dart';

class MainNavigationState extends Equatable {
  final int index;

  const MainNavigationState({required this.index});

  @override
  List<Object> get props => [index];
}
