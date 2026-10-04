// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Aplikasi Starterkit';

  @override
  String welcomeUser(String name) {
    return 'Selamat datang, $name!';
  }

  @override
  String itemRemaining(int count) {
    return 'Anda memiliki $count tugas tertunda';
  }

  @override
  String get splashTagline => 'Aplikasi pendamping cerdas Anda';

  @override
  String get splashLoading => 'Menyiapkan aplikasi...';

  @override
  String splashVersion(String version) {
    return 'Versi $version';
  }

  @override
  String get homeTitle => 'Beranda';

  @override
  String get homeWelcome => 'Selamat Datang di Halaman Beranda!';

  @override
  String get accountTitle => 'Akun';

  @override
  String get accountGuestUser => 'Pengguna Tamu';

  @override
  String get accountGuestUserDesc => 'Masuk untuk mengakses semua fitur akun';

  @override
  String get accountBtnLogin => 'Masuk';

  @override
  String get accountBtnRegister => 'Daftar';

  @override
  String get accountSectionPreferences => 'PENGATURAN';

  @override
  String get accountThemeDarkMode => 'Mode Gelap';

  @override
  String get accountThemeActive => 'Aktif';

  @override
  String get accountThemeInactive => 'Nonaktif';

  @override
  String get accountLanguage => 'Bahasa';

  @override
  String get accountLanguageSelectTitle => 'Pilih Bahasa';

  @override
  String get accountLanguageIndonesian => 'Bahasa Indonesia';

  @override
  String get accountLanguageEnglish => 'Bahasa Inggris';

  @override
  String get accountSectionAbout => 'TENTANG';

  @override
  String get accountAboutHelpCenter => 'Pusat Bantuan & FAQ';

  @override
  String get accountAboutPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get accountAboutAppVersion => 'Versi Aplikasi';

  @override
  String get accountSectionDevTools => 'ALAT PENGEMBANG';

  @override
  String get accountDevNotificationSending => 'Mengirim...';

  @override
  String get accountDevBtnTestNotification => 'Uji Notifikasi Lokal';

  @override
  String get accountDevBtnTestImageNotification => 'Uji Notifikasi Bergambar';
}
