import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/states/local_notification/local_notification_cubit.dart';
import '../../../../core/states/theme/theme_cubit.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                tooltip: state.isDark
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                onPressed: () {
                  context.read<ThemeCubit>().toggleTheme();
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    state.isDark
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    key: ValueKey(state.isDark),
                  ),
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.person_rounded, size: 64),

                const SizedBox(height: 16),

                Text(
                  'Welcome to the Account Screen!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 32),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BlocConsumer<
                      LocalNotificationCubit,
                      LocalNotificationState
                    >(
                      listener: (context, state) {
                        if (state.isSuccess || state.isFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message ?? '')),
                          );

                          context.read<LocalNotificationCubit>().reset();
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<LocalNotificationCubit>()
                                            .testNotification();
                                      },
                                icon: state.isLoading
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.notifications_active_rounded,
                                      ),
                                label: Text(
                                  state.isLoading
                                      ? 'Sending...'
                                      : 'Test Local Notification',
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                onPressed: state.isLoading
                                    ? null
                                    : () {
                                        context
                                            .read<LocalNotificationCubit>()
                                            .testNotificationWithImage();
                                      },
                                icon: const Icon(Icons.image_rounded),
                                label: const Text(
                                  'Test Notification With Image',
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
