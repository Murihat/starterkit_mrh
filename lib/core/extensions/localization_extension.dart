import 'package:flutter/material.dart';

import '../../app/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
