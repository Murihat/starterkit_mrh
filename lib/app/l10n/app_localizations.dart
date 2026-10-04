import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Starterkit App'**
  String get appTitle;

  /// Greeting text with name placeholder
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeUser(String name);

  /// Task counter placeholder
  ///
  /// In en, this message translates to:
  /// **'You have {count} pending tasks'**
  String itemRemaining(int count);

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'Your smart companion app'**
  String get splashTagline;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Preparing application...'**
  String get splashLoading;

  /// No description provided for @splashVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String splashVersion(String version);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Home Screen!'**
  String get homeWelcome;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @accountGuestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest User'**
  String get accountGuestUser;

  /// No description provided for @accountGuestUserDesc.
  ///
  /// In en, this message translates to:
  /// **'Sign in to access all account features'**
  String get accountGuestUserDesc;

  /// No description provided for @accountBtnLogin.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get accountBtnLogin;

  /// No description provided for @accountBtnRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get accountBtnRegister;

  /// No description provided for @accountSectionPreferences.
  ///
  /// In en, this message translates to:
  /// **'PREFERENCES'**
  String get accountSectionPreferences;

  /// No description provided for @accountThemeDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get accountThemeDarkMode;

  /// No description provided for @accountThemeActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get accountThemeActive;

  /// No description provided for @accountThemeInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get accountThemeInactive;

  /// No description provided for @accountLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get accountLanguage;

  /// No description provided for @accountLanguageSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get accountLanguageSelectTitle;

  /// No description provided for @accountLanguageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get accountLanguageIndonesian;

  /// No description provided for @accountLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get accountLanguageEnglish;

  /// No description provided for @accountSectionAbout.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get accountSectionAbout;

  /// No description provided for @accountAboutHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center & FAQ'**
  String get accountAboutHelpCenter;

  /// No description provided for @accountAboutPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get accountAboutPrivacyPolicy;

  /// No description provided for @accountAboutAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get accountAboutAppVersion;

  /// No description provided for @accountSectionDevTools.
  ///
  /// In en, this message translates to:
  /// **'DEVELOPER TOOLS'**
  String get accountSectionDevTools;

  /// No description provided for @accountDevNotificationSending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get accountDevNotificationSending;

  /// No description provided for @accountDevBtnTestNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Local Notification'**
  String get accountDevBtnTestNotification;

  /// No description provided for @accountDevBtnTestImageNotification.
  ///
  /// In en, this message translates to:
  /// **'Test Notification With Image'**
  String get accountDevBtnTestImageNotification;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
