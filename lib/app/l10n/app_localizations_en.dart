// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Starterkit App';

  @override
  String welcomeUser(String name) {
    return 'Welcome, $name!';
  }

  @override
  String itemRemaining(int count) {
    return 'You have $count pending tasks';
  }

  @override
  String get splashTagline => 'Your smart companion app';

  @override
  String get splashLoading => 'Preparing application...';

  @override
  String splashVersion(String version) {
    return 'Version $version';
  }

  @override
  String get homeTitle => 'Home';

  @override
  String get homeWelcome => 'Welcome to the Home Screen!';

  @override
  String get authLoginTitle => 'Login';

  @override
  String get authLoginSubtitle => 'Please enter your details to sign in';

  @override
  String get authEmailLabel => 'Email Address';

  @override
  String get authEmailHint => 'Enter your email';

  @override
  String get authEmailEmpty => 'Email cannot be empty';

  @override
  String get authEmailInvalid => 'Please enter a valid email';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Enter your password';

  @override
  String get authPasswordEmpty => 'Password cannot be empty';

  @override
  String get authForgotPassword => 'Forgot Password?';

  @override
  String get authBtnSignIn => 'Sign In';

  @override
  String get authOrDivider => 'OR CONTINUE WITH';

  @override
  String get authBtnGoogle => 'Sign In with Google';

  @override
  String get authNoAccount => 'Don\'t have an account?';

  @override
  String get authBtnSignUp => 'Sign Up';

  @override
  String get accountTitle => 'Account';

  @override
  String get accountGuestUser => 'Guest User';

  @override
  String get accountGuestUserDesc => 'Sign in to access all account features';

  @override
  String get accountBtnLogin => 'Sign In';

  @override
  String get accountBtnRegister => 'Register';

  @override
  String get accountSectionPreferences => 'PREFERENCES';

  @override
  String get accountThemeDarkMode => 'Dark Mode';

  @override
  String get accountThemeActive => 'Active';

  @override
  String get accountThemeInactive => 'Inactive';

  @override
  String get accountLanguage => 'Language';

  @override
  String get accountLanguageSelectTitle => 'Select Language';

  @override
  String get accountLanguageIndonesian => 'Indonesian';

  @override
  String get accountLanguageEnglish => 'English';

  @override
  String get accountSectionAbout => 'ABOUT';

  @override
  String get accountAboutHelpCenter => 'Help Center & FAQ';

  @override
  String get accountAboutPrivacyPolicy => 'Privacy Policy';

  @override
  String get accountAboutAppVersion => 'App Version';

  @override
  String get accountSectionDevTools => 'DEVELOPER TOOLS';

  @override
  String get accountDevNotificationSending => 'Sending...';

  @override
  String get accountDevBtnTestNotification => 'Test Local Notification';

  @override
  String get accountDevBtnTestImageNotification =>
      'Test Notification With Image';
}
