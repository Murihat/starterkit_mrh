# Starterkit MRH

Starterkit Flutter berbasis Material 3 untuk menjadi fondasi aplikasi mobile. Proyek ini menyediakan struktur modular, dependency injection, state management BLoC/Cubit, routing, konfigurasi environment, penyimpanan aman, pengecekan koneksi, pemeriksaan keamanan perangkat, serta dukungan light dan dark mode.

## Teknologi utama

| Kebutuhan | Implementasi |
| --- | --- |
| Framework | Flutter (Dart SDK `^3.12.2`) |
| State management | `flutter_bloc` dan `equatable` |
| Dependency injection | `get_it` |
| Routing | `go_router` |
| HTTP client | `dio` |
| Secure storage | `flutter_secure_storage` |
| Environment | `flutter_dotenv` |
| Konektivitas | `connectivity_plus` |
| Pemeriksaan perangkat | `safe_device` |
| UI responsive | `flutter_screenutil` |
| Notifikasi UI | `toastification`, `flutter_local_notifications` |

## Fitur yang sudah tersedia

- Bootstrap aplikasi dengan penanganan error melalui `runZonedGuarded`.
- Konfigurasi environment melalui file `.env`.
- Dependency injection terpusat menggunakan GetIt.
- Tema Material 3 untuk light mode dan dark mode.
- Preferensi tema disimpan secara aman di perangkat.
- Tombol penggantian tema pada halaman Main Navigation.
- Bottom navigation Material 3 untuk route Home dan Account.
- Routing deklaratif menggunakan GoRouter.
- Splash screen animatif yang mengarahkan pengguna ke `/home`.
- Overlay offline ketika perangkat tidak terhubung ke jaringan.
- Pemeriksaan keamanan perangkat untuk mock location, root/jailbreak, developer mode, dan penyimpanan eksternal sesuai platform.
- API client berbasis Dio dengan token Bearer, header perangkat, multipart upload, download file, dan pemetaan error HTTP.
- Identitas perangkat yang persisten untuk kebutuhan request API.
- Layanan secure storage untuk string dan object JSON.
- Layanan logging dan observer BLoC.
- Dukungan Android, iOS, web, Windows, macOS, dan Linux dari struktur Flutter standar.

## Struktur proyek

```text
.
├── android/                         # Konfigurasi dan runner Android
├── ios/                             # Konfigurasi dan runner iOS
├── web/                             # Runner web dan manifest
├── windows/                         # Runner Windows
├── macos/                           # Runner macOS
├── linux/                           # Runner Linux
├── assets/                          # Asset aplikasi: images, icons, fonts
├── env/                             # File environment (.env)
├── test/                            # Widget/integration test
├── lib/
│   ├── main.dart                    # Entry point aplikasi
│   ├── app/
│   │   ├── app.dart                 # MaterialApp, tema, router, global wrapper
│   │   ├── bootstrap.dart            # Inisialisasi Flutter, env, DI, dan error zone
│   │   ├── config/
│   │   │   └── app_config.dart      # Pembacaan APP_NAME, BASE_URL, API_KEY, ENABLE_LOG
│   │   ├── di/
│   │   │   └── injection.dart       # Registrasi service dan BLoC/Cubit pada GetIt
│   │   ├── observer/
│   │   │   └── app_observer.dart    # Observer perubahan state BLoC
│   │   ├── providers/
│   │   │   └── app_providers.dart   # Global BlocProvider
│   │   ├── routes/
│   │   │   └── app_router.dart      # Definisi route dan ShellRoute
│   │   └── themes/
│   │       ├── app_color.dart       # Token warna aplikasi
│   │       ├── app_font.dart        # Konstanta ukuran font
│   │       └── app_theme.dart       # ThemeData light dan dark Material 3
│   ├── core/
│   │   ├── base/
│   │   │   └── base_cubit.dart      # Base Cubit dengan safe emit
│   │   ├── models/
│   │   │   ├── device_info/         # Model metadata perangkat
│   │   │   └── safe_device/         # Model hasil pemeriksaan perangkat
│   │   ├── network/
│   │   │   ├── api_client.dart       # Client Dio dan interceptor API
│   │   │   └── api_exception.dart    # Exception API terstruktur
│   │   ├── services/
│   │   │   ├── connectivity/        # Status konektivitas perangkat
│   │   │   ├── device/              # Pengambilan dan penyimpanan device info
│   │   │   ├── logger/              # Layanan logging
│   │   │   ├── safe_device/         # Pemeriksaan keamanan perangkat
│   │   │   └── storage/             # Secure storage dan key tersimpan
│   │   └── wrappers/
│   │       ├── connectivity/        # BLoC dan layar overlay offline
│   │       ├── security/            # Cubit dan layar perangkat tidak aman
│   │       └── theme/               # Cubit dan state pengaturan tema
│   └── features/
│       ├── splash/                  # Splash page/screen
│       ├── login/                   # Login page/screen
│       ├── signup/                  # Sign-up page/screen
│       ├── maintenance/             # Maintenance page/screen
│       └── main_navigation/         # Shell, bottom navigation, dan pengubah tema
├── pubspec.yaml                     # Dependency dan konfigurasi Flutter
└── analysis_options.yaml             # Aturan static analysis/lint
```

Setiap feature/wrapper memisahkan `pages` (komposisi atau entry widget) dan `screens` (implementasi tampilan). State yang relevan berada di folder `bloc` atau `cubit`.

## Alur inisialisasi aplikasi

```text
main()
  → bootstrap()
    → WidgetsFlutterBinding.ensureInitialized()
    → memuat env/.env.dev (atau nilai --dart-define ENV)
    → initDependencies()
    → mengambil preferensi tema dari secure storage
    → MultiBlocProvider
    → App
      → MaterialApp.router
        → ConnectivityPage
          → SecurityPage
            → route aktif
```

`bootstrap` juga mengunci orientasi ke portrait (`DeviceOrientation.portraitUp`) dan menangkap error asynchronous untuk diteruskan ke `LoggerService`.

## Routing

| Nama route | Path | Halaman | Keterangan |
| --- | --- | --- | --- |
| `splash` | `/` | `SplashPage` | Route awal; setelah sekitar 2 detik menuju home. |
| `maintenance` | `/maintenance` | `MaintenancePage` | Halaman pemeliharaan. |
| `login` | `/login` | `LoginPage` | Halaman login. |
| `signup` | `/login/signup` | `SignupPage` | Child route dari login. |
| `home` | `/home` | Scaffold Home | Berjalan di dalam `ShellRoute` Main Navigation. |
| `account` | `/account` | Scaffold Account | Berjalan di dalam `ShellRoute` Main Navigation. |

Untuk menambah route utama yang menggunakan shell navigation, tambahkan `GoRoute` pada daftar `routes` milik `ShellRoute` di `lib/app/routes/app_router.dart`.

## Tema: light dan dark mode

Tema dikelola oleh `ThemeCubit` dan dipasang pada `MaterialApp.router` melalui `theme`, `darkTheme`, dan `themeMode`.

- Tema awal adalah light mode jika belum ada preferensi tersimpan.
- Nilai `light` atau `dark` disimpan memakai `FlutterSecureStorage` dengan key `theme_mode`.
- Tema tersimpan dibaca sebelum `runApp`, lalu diberikan sebagai `initialTheme` ke `ThemeCubit`.
- `ThemeCubit.toggleTheme()` digunakan oleh tombol pada `MainNavigationScreen`.
- Kedua tema menggunakan Material 3, font family `OpenSans`, seed color hijau tua `#0F4C4A`, serta card/dialog/bottom sheet tanpa surface tint.

Token warna utama berada pada `lib/app/themes/app_color.dart`:

| Token | Nilai |
| --- | --- |
| Primary | `#0F4C4A` |
| Secondary | `#C8A24D` |
| Light background / surface / text | `#F6F8F7` / `#FFFFFF` / `#1F1F1F` |
| Dark background / surface / text | `#121212` / `#1E1E1E` / `#FFFFFF` |
| Success / warning / error | `#2E7D32` / `#ED9D00` / `#D32F2F` |

Saat membuat UI baru, gunakan `Theme.of(context).colorScheme` atau token tema daripada memberi warna tetap pada widget. Ini menjaga tampilan konsisten pada kedua mode.

## Global state dan wrapper

Provider global dibuat di `AppProviders`:

- `ThemeCubit`: memuat dan mengubah preferensi tema.
- `ConnectivityBloc`: memantau konektivitas dan menampilkan `ConnectivityScreen` sebagai overlay saat offline.
- `SecurityCubit`: menjalankan pemeriksaan perangkat saat startup.
- `MainNavigationCubit`: menyimpan index tujuan bottom navigation.

`ConnectivityPage` dan `SecurityPage` membungkus seluruh router dari `App`, sehingga perilaku koneksi dan keamanan dapat diterapkan secara global.

## Keamanan perangkat

`SafeDeviceService` memakai package `safe_device` untuk mengambil sinyal keamanan berikut:

- Status jailbreak/root dan detail pendeteksiannya.
- Keaslian perangkat (`isRealDevice`) dan keamanan perangkat (`isSafeDevice`).
- Mock location, developer mode, dan external storage di Android.
- Custom jailbreak check dan jailbreak details di iOS.

Jika status `SecurityStatus.isMockLocation` diterima, `SecurityScreen` menampilkan halaman **Device Not Secure** dan menyediakan tombol untuk menutup aplikasi. Perluas kondisi ini di `SecurityCubit` sesuai kebijakan keamanan aplikasi sebelum production release.

## Konfigurasi environment

Secara default aplikasi memuat `env/.env.dev`. Lokasi file dapat diganti ketika menjalankan aplikasi:

```bash
flutter run --dart-define=ENV=env/.env.prod
```

Key environment yang digunakan oleh `AppConfig`:

```env
APP_NAME=Starterkit MRH
BASE_URL=http://localhost:8000
API_KEY=
ENABLE_LOG=true
```

Fallback bawaan jika key tidak tersedia:

- `APP_NAME`: `Starterkit MRH`
- `BASE_URL`: `http://localhost:8000`
- `API_KEY`: string kosong
- `ENABLE_LOG`: `false`

Jangan menyimpan secret production di source control. Gunakan file environment lokal atau mekanisme secret pada CI/CD.

## Penyimpanan lokal

`StorageService` menggunakan `FlutterSecureStorage` dan mendukung:

- `write` / `read` untuk string.
- `writeObject` / `readObject` untuk `Map<String, dynamic>` dalam format JSON.
- `delete`, `clear`, dan `containsKey`.
- `getThemeMode` untuk memulihkan tema tersimpan.

Key yang tersedia saat ini:

| Key | Kegunaan |
| --- | --- |
| `auth_member` | Data member/auth pengguna. |
| `auth_token` | Token autentikasi. |
| `theme_mode` | Preferensi `light` atau `dark`. |
| `device_id` | UUID perangkat yang dibuat sekali dan digunakan kembali. |

## API client dan device info

`ApiClient` adalah wrapper Dio yang memakai `AppConfig.baseUrl` sebagai base URL. Ia menyediakan method berikut:

- `getForm`, `postForm`, `putForm`, dan `deleteForm` untuk request JSON/form.
- `postMultipart` untuk pengiriman `FormData`.
- `downloadFile` untuk mengunduh file ke lokasi yang diberikan.
- Parameter `authRequired` pada setiap request; bila aktif dan token tersedia, interceptor menambahkan header `Authorization: Bearer <token>`.

Interceptor juga menambahkan metadata perangkat pada setiap request:

```text
X-Device-Id
X-Platform
X-App-Version
X-Build-Number
X-OS-Version
X-Device-Model
```

`DeviceService` membentuk `DeviceInfoModel` dari `device_info_plus` dan `package_info_plus`. Device ID dibuat sebagai UUID dengan prefix `StarterApp-`, kemudian disimpan dengan key `device_id` sehingga tetap konsisten antar sesi.

Respons non-2xx dipetakan menjadi `BadRequestException` (400), `UnauthorizedException` (401), `ForbiddenException` (403), `NotFoundException` (404), `ServerException` (500), atau `ApiException`. Timeout, koneksi gagal, pembatalan request, dan error jaringan juga dipetakan ke `ApiException` yang mudah ditangani feature layer.

## Menjalankan proyek

### Prasyarat

- Flutter SDK yang kompatibel dengan Dart `^3.12.2`.
- Perangkat fisik, emulator, simulator, atau browser target yang telah dikonfigurasi.

### Instalasi

```bash
flutter pub get
```

### Menjalankan development

```bash
flutter run
```

Untuk memilih environment lain:

```bash
flutter run --dart-define=ENV=env/.env.dev
```

### Static analysis dan test

```bash
flutter analyze
flutter test
```

### Build release

```bash
flutter build apk
flutter build appbundle
flutter build ios
flutter build web
```

Gunakan perintah build yang sesuai target platform dan pastikan konfigurasi signing/native project telah disiapkan untuk rilis.

## Assets dan font

Folder berikut didaftarkan di `pubspec.yaml`:

```text
env/
assets/
assets/images/
assets/icons/
assets/fonts/
```

Tema sudah menggunakan `fontFamily: OpenSans`. Agar font diterapkan dengan benar, daftarkan keluarga `OpenSans` beserta file font-nya pada bagian `fonts:` di `pubspec.yaml` apabila belum dilakukan.

## Konvensi pengembangan

- Daftarkan service singleton atau factory baru di `lib/app/di/injection.dart`.
- Akses dependency yang sudah terdaftar melalui `sl<T>()`; `ApiClient` sudah memperoleh token dan `DeviceService` melalui DI.
- Daftarkan BLoC/Cubit yang harus tersedia secara global di `lib/app/providers/app_providers.dart`.
- Tambahkan route melalui `lib/app/routes/app_router.dart` dan simpan konstanta nama route di `AppRouteName`.
- Simpan token UI bersama dalam `app/themes`.
- Letakkan logika reusable lintas feature di `core/`; UI dan use case khusus tetap di `features/`.
- Gunakan `BaseCubit.safeEmit` untuk Cubit yang meng-emit state asynchronous.

## Dependensi

Dependency lengkap serta versinya ada di [`pubspec.yaml`](pubspec.yaml). Dependensi yang belum terlihat digunakan pada UI saat ini tetap tersedia sebagai bagian dari starterkit, antara lain `cached_network_image`, `flutter_svg`, `shimmer`, `permission_handler`, `package_info_plus`, dan `flutter_local_notifications`.

## Catatan pengembangan

- Delegasi lokalisasi Material/Cupertino sudah disiapkan sebagai komentar di `App`, tetapi belum diaktifkan.
- `debugShowCheckedModeBanner` mengikuti nilai `ENABLE_LOG`; gunakan `false` pada environment rilis.
- `debugLogDiagnostics` GoRouter aktif. Pertimbangkan menonaktifkannya pada production.
- Halaman Login, Sign Up, Maintenance, Home, dan Account saat ini masih berupa placeholder dasar untuk dikembangkan lebih lanjut.
