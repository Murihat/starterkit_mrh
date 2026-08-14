import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../states/connectivity/connectivity_bloc.dart';
import '../screens/connectivity_screen.dart';

class ConnectivityPage extends StatelessWidget {
  final Widget child;

  const ConnectivityPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityBloc, ConnectivityState>(
      listenWhen: (previous, current) => !previous.isOnline && current.isOnline,
      listener: (context, state) {
        // context.read<AppUpdateCubit>().check();
      },
      builder: (_, state) {
        // if (!state.isOnline) {
        //   return const OfflinePage();
        // }
        // return child;
        return Stack(
          children: [child, if (!state.isOnline) const ConnectivityScreen()],
        );
      },
    );
  }
}
