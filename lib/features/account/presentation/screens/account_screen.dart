import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/localization_extension.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/states/local_notification/local_notification_cubit.dart';
import '../../../../core/states/locale/locale_cubit.dart';
import '../../../../core/states/theme/theme_cubit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.accountTitle),
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      body: BlocListener<LocalNotificationCubit, LocalNotificationState>(
        listener: (context, state) {
          if (state.isSuccess || state.isFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? ''),
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.read<LocalNotificationCubit>().reset();
          }
        },
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            const _GuestHeaderCard(),
            const SizedBox(height: 24),
            _SectionHeader(title: context.l10n.accountSectionPreferences),
            const SizedBox(height: 8),
            const _PreferencesCard(),
            const SizedBox(height: 24),
            _SectionHeader(title: context.l10n.accountSectionAbout),
            const SizedBox(height: 8),
            const _AboutCard(),
            const SizedBox(height: 24),
            _SectionHeader(title: context.l10n.accountSectionDevTools),
            const SizedBox(height: 8),
            const _DevToolsCard(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// SUB-COMPONENTS
// ============================================================================

class _GuestHeaderCard extends StatelessWidget {
  const _GuestHeaderCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: context.colorScheme.outline.withOpacity(0.4)),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: context.colorScheme.onPrimary,
            child: Icon(
              Icons.person_outline_rounded,
              size: 40,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.accountGuestUser,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.accountGuestUserDesc,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: () {},
                  child: Text(context.l10n.accountBtnLogin),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: Text(context.l10n.accountBtnRegister),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreferencesCard extends StatelessWidget {
  const _PreferencesCard();

  void _showLanguageSheet(BuildContext context) {
    final currentCode = context.read<LocaleCubit>().state.locale.languageCode;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      sheetContext.l10n.accountLanguageSelectTitle,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Text('🇮🇩', style: TextStyle(fontSize: 24)),
                  title: Text(sheetContext.l10n.accountLanguageIndonesian),
                  trailing: currentCode == 'id'
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: context.colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    context.read<LocaleCubit>().setIndonesian();
                    Navigator.pop(sheetContext);
                  },
                ),
                ListTile(
                  leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
                  title: Text(sheetContext.l10n.accountLanguageEnglish),
                  trailing: currentCode == 'en'
                      ? Icon(
                          Icons.check_circle_rounded,
                          color: context.colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    context.read<LocaleCubit>().setEnglish();
                    Navigator.pop(sheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              return SwitchListTile.adaptive(
                secondary: Icon(
                  themeState.isDark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  color: context.colorScheme.primary,
                ),
                title: Text(context.l10n.accountThemeDarkMode),
                subtitle: Text(
                  themeState.isDark
                      ? context.l10n.accountThemeActive
                      : context.l10n.accountThemeInactive,
                  style: context.textTheme.bodySmall,
                ),
                value: themeState.isDark,
                onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          Divider(
            height: 1,
            indent: 56,
            color: context.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          BlocBuilder<LocaleCubit, LocaleState>(
            builder: (context, localeState) {
              final isId = localeState.locale.languageCode == 'id';
              return ListTile(
                leading: Icon(
                  Icons.language_rounded,
                  color: context.colorScheme.primary,
                ),
                title: Text(context.l10n.accountLanguage),
                subtitle: Text(
                  isId
                      ? '🇮🇩 ${context.l10n.accountLanguageIndonesian}'
                      : '🇬🇧 ${context.l10n.accountLanguageEnglish}',
                  style: context.textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _showLanguageSheet(context),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.help_outline_rounded,
              color: colorScheme.primary,
            ),
            title: Text(context.l10n.accountAboutHelpCenter),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          Divider(
            height: 1,
            indent: 56,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          ListTile(
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: colorScheme.primary,
            ),
            title: Text(context.l10n.accountAboutPrivacyPolicy),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {},
          ),
          Divider(
            height: 1,
            indent: 56,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline_rounded,
              color: colorScheme.primary,
            ),
            title: Text(context.l10n.accountAboutAppVersion),
            trailing: Text(
              'v1.0.0',
              style: context.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DevToolsCard extends StatelessWidget {
  const _DevToolsCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<LocalNotificationCubit, LocalNotificationState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.tonalIcon(
                  onPressed: state.isLoading
                      ? null
                      : () => context
                            .read<LocalNotificationCubit>()
                            .testNotification(),
                  icon: state.isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.notifications_active_rounded),
                  label: Text(
                    state.isLoading
                        ? context.l10n.accountDevNotificationSending
                        : context.l10n.accountDevBtnTestNotification,
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: state.isLoading
                      ? null
                      : () => context
                            .read<LocalNotificationCubit>()
                            .testNotificationWithImage(),
                  icon: const Icon(Icons.image_rounded),
                  label: Text(context.l10n.accountDevBtnTestImageNotification),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title,
        style: context.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.8,
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
