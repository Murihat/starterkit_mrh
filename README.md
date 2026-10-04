# Starterkit MRH

Starterkit aplikasi Flutter berbasis Material 3. Repository ini menyediakan fondasi aplikasi mobile/web: bootstrap dan konfigurasi, routing, state global dengan BLoC/Cubit, tema dan bahasa, layanan perangkat, penyimpanan lokal aman, serta client HTTP. Fitur produk seperti autentikasi dan halaman utama masih berupa UI awal; belum ada alur autentikasi atau integrasi backend khusus fitur.

## Teknologi

- Flutter dan Dart (`pubspec.yaml` menetapkan SDK `^3.12.2`)
- `flutter_bloc` dan `equatable` untuk state management
- `get_it` untuk dependency injection
- `go_router` untuk routing
- `dio` untuk HTTP
- `flutter_secure_storage` untuk penyimpanan sensitif
- `flutter_dotenv` untuk konfigurasi environment
- `connectivity_plus`, `safe_device`, `device_info_plus`, dan `package_info_plus` untuk informasi perangkat
- `flutter_local_notifications` untuk notifikasi lokal
- `flutter_localizations` dan file ARB untuk lokalisasi Indonesia dan Inggris

Versi lengkap dependency tercantum di [`pubspec.yaml`](pubspec.yaml).

## Gambaran arsitektur

```text
lib/
├── main.dart                  # Entry point
├── app/                       # Bootstrap, konfigurasi, DI, routing, tema, provider, lokalisasi
├── core/                      # Layanan bersama, model perangkat, jaringan, state, wrapper, extension
└── features/                  # Modul UI fitur
    ├── account/
    ├── home/
    ├── login/
    ├── main_navigation/
    ├── maintenance/
    ├── signup/
    └── splash/
```

`app/` mengatur komposisi aplikasi. `core/` menampung kapabilitas lintas fitur seperti `ApiClient`, `StorageService`, layanan konektivitas/perangkat, serta state tema, bahasa, keamanan, dan notifikasi. Tiap folder fitur yang tersedia membagi UI menjadi `pages/` dan `screens/`; hanya navigasi utama yang memiliki Cubit sendiri.

Struktur saat ini berorientasi UI dan layanan bersama, belum menerapkan lapisan domain/data atau pola repository/use case secara konsisten. Saat menambahkan fitur yang terhubung ke backend, pisahkan model dan logika fitur dari widget agar batas tanggung jawabnya jelas.

## Siklus aplikasi

1. `main()` memanggil `bootstrap()`.
2. Bootstrap menyiapkan Flutter, menangkap error framework/platform/zona, mengunci orientasi portrait, memuat file environment, mendaftarkan dependency, lalu menginisialisasi notifikasi lokal.
3. `AppProviders` menyediakan state global: konektivitas, pemeriksaan keamanan, tema, bahasa, dan notifikasi.
4. `App` memasang `ScreenUtil`, lokalisasi, tema, router, dan wrapper konektivitas serta keamanan.
5. Router membuka Splash (`/`); setelah dua detik Splash mengarahkan pengguna ke Home (`/home`).

## Routing dan halaman

Route didefinisikan di [`lib/app/routes/app_router.dart`](lib/app/routes/app_router.dart).

| Path | Halaman | Catatan |
| --- | --- | --- |
| `/` | Splash | Mengarah ke `/home` setelah dua detik. |
| `/maintenance` | Maintenance | Halaman informasi maintenance. |
| `/login` | Login | UI form login; autentikasi belum terhubung. |
| `/login/signup` | Sign Up | Child route login; UI dasar. |
| `/home` | Home | Cabang pertama `StatefulShellRoute`. |
| `/account` | Account | Cabang kedua `StatefulShellRoute`. |

Home dan Account berbagi `MainNavigationPage` dengan navigasi bawah dan mempertahankan stack tiap cabang. Login, Home, Account, Sign Up, dan Maintenance adalah titik awal UI, bukan fitur backend yang telah selesai.

## State global dan wrapper

`AppProviders` membuat:

- `ConnectivityBloc` untuk memantau koneksi. Wrapper konektivitas menampilkan layar offline saat status dianggap terputus.
- `SecurityCubit` untuk memeriksa perangkat. Wrapper keamanan menahan konten utama pada beberapa status perangkat yang tidak lolos pemeriksaan.
- `ThemeCubit` dan `LocaleCubit` untuk preferensi tampilan dan bahasa.
- `LocalNotificationCubit` untuk state notifikasi lokal.

Dependency service didaftarkan di [`lib/app/di/injection.dart`](lib/app/di/injection.dart) melalui GetIt (`sl<T>()`). Tambahkan dependency global di sana dan provider global di [`lib/app/providers/app_providers.dart`](lib/app/providers/app_providers.dart) bila memang diperlukan di seluruh aplikasi.

## Tema dan bahasa

Tema Material 3 light/dark disusun di `lib/app/themes/`. Preferensi `light` atau `dark` disimpan pada secure storage dengan key `theme_mode`. Cubit memuat preferensi setelah provider dibuat; state awal sebelum pemuatan adalah light. Bahasa didukung dalam Bahasa Indonesia (`id-ID`) dan Inggris (`en-US`), menggunakan file ARB di `lib/app/l10n/` dan preferensi `app_locale`.

Saat menambah string terjemahan, perbarui kedua file ARB dan jalankan generator lokalisasi Flutter sesuai konfigurasi proyek. Gunakan `context.l10n` dan warna dari theme/color scheme pada UI.

## Environment

Bootstrap memuat `env/.env.dev` secara default. Path alternatif diberikan melalui `--dart-define=ENV`:

```bash
flutter run --dart-define=ENV=env/.env.dev
```

`AppConfig` membaca key berikut:

| Key | Default jika tidak tersedia |
| --- | --- |
| `APP_NAME` | `Starterkit MRH` |
| `BASE_URL` | `http://localhost:8000` |
| `API_KEY` | string kosong |
| `ENABLE_LOG` | `false` |

`ApiClient` menambahkan `/api` pada `BASE_URL`. Sesuaikan alamat server dengan target yang digunakan; `localhost` pada emulator/perangkat mengacu pada perangkat itu sendiri, bukan otomatis komputer host. File environment tersedia di `env/`. Hindari memasukkan kredensial atau secret produksi ke version control.

## Jaringan dan penyimpanan

`ApiClient` membungkus Dio dengan timeout, pemetaan error ke `ApiException` dan turunannya, serta helper GET/POST/PUT/DELETE, multipart, dan download. Request menerima `authRequired`; interceptor menambahkan Bearer token jika diminta dan tersedia, serta header metadata perangkat (`X-Device-Id`, platform, versi aplikasi, versi OS, dan model). `API_KEY` tersedia di konfigurasi, tetapi client saat ini tidak memasangnya otomatis sebagai header.

`StorageService` membungkus `FlutterSecureStorage` untuk string dan object JSON. Key yang terdefinisi meliputi `auth_member`, `auth_token`, `theme_mode`, `device_id`, dan `app_locale`. Device ID dibuat dan dipersistenkan oleh `DeviceService`.

## Menyiapkan dan menjalankan

Prasyarat: Flutter SDK yang mendukung batas Dart pada `pubspec.yaml`, serta toolchain platform tujuan.

```bash
flutter pub get
flutter run
```

Target yang didukung mengikuti folder platform di repository: Android, iOS, web, Windows, macOS, dan Linux. Ketersediaan build dan perilaku plugin dapat berbeda per platform; siapkan toolchain dan konfigurasi native/signing sesuai target.

Perintah pemeriksaan dan build yang umum:

```bash
flutter analyze
flutter test
flutter build apk
flutter build appbundle
flutter build ios
flutter build web
```

## Assets

Asset dan font didaftarkan di `pubspec.yaml`. Direktori yang digunakan adalah `assets/images/`, `assets/icons/`, `assets/fonts/`, dan `env/`. Keluarga font OpenSans dideklarasikan dengan file font di `assets/fonts/`. Ikon aplikasi dikonfigurasi menggunakan `assets/images/app_icon.png`.

## Pengembangan

- Definisikan route baru di `lib/app/routes/app_router.dart` dan nama route di `AppRouteName`.
- Tambahkan service reusable di `core/services/`; jaga logika spesifik produk tetap di modul `features/`.
- Tambahkan state global hanya jika dipakai lintas aplikasi; state layar/fitur sebaiknya berada dekat dengan fiturnya.
- Gunakan theme, extension, dan string lokalisasi yang tersedia untuk menjaga UI konsisten.
- Kode test saat ini berada di `test/`; sesuaikan atau tambahkan pengujian saat mengembangkan fitur.

