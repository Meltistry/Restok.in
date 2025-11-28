# ReStock.in 📦

**Restock Management App** - Aplikasi manajemen restok invoice untuk toko dan UMKM.

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-blue)
![Supabase](https://img.shields.io/badge/Supabase-2.0.0-green)
![Google Sign In](https://img.shields.io/badge/Google_Sign_In-6.3.0-red)

## 📋 Deskripsi

ReStock.in adalah aplikasi mobile untuk membantu pemilik toko dan UMKM mengelola invoice restok barang dengan lebih mudah dan efisien.

---

## 🚀 Setup Project

### Prerequisites

Pastikan sudah terinstall:
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (versi 3.9.2 atau lebih baru)
- [Dart SDK](https://dart.dev/get-dart) (bundled dengan Flutter)
- Android Studio / Xcode (untuk development mobile)
- Git

### 1. Clone Repository

```bash
git clone https://github.com/Meltistry/Restok.in.git
cd restokin
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi Environment

Copy file `.env.example` menjadi `.env` (atau gunakan `lib/core/config/supabase_config.dart`):

```bash
cp .env.example .env
```

---

## 🔧 Setup Supabase

### 1. Buat Project Supabase

1. Buka [Supabase Dashboard](https://supabase.com/dashboard)
2. Klik **"New Project"**
3. Isi detail project:
   - **Name**: ReStock.in
   - **Database Password**: (simpan password ini)
   - **Region**: Singapore (atau terdekat)
4. Klik **"Create new project"**

### 2. Dapatkan Credentials

1. Buka project Supabase Anda
2. Pergi ke **Settings** → **API**
3. Copy credentials berikut:
   - **Project URL** (contoh: `https://xxxxx.supabase.co`)
   - **anon/public key**

### 3. Update Konfigurasi

Edit file `lib/core/config/supabase_config.dart`:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://xxxxx.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
}
```

### 4. Setup Google OAuth (Opsional)

#### A. Google Cloud Console

1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Buat project baru atau pilih yang ada
3. Aktifkan **OAuth consent screen**
4. Buat **OAuth 2.0 Client ID** (Web application):
   - **Authorized JavaScript origins**:
     ```
     https://xxxxx.supabase.co
     ```
   - **Authorized redirect URIs**:
     ```
     https://xxxxx.supabase.co/auth/v1/callback
     ```
5. Copy **Client ID** dan **Client Secret**

#### B. Supabase Dashboard

1. Buka **Authentication** → **Providers** → **Google**
2. Enable Google provider
3. Paste **Client ID** dan **Client Secret**
4. Klik **Save**

#### C. URL Configuration

1. Buka **Authentication** → **URL Configuration**
2. Tambahkan **Redirect URLs**:
   ```
   io.supabase.restokin://login-callback
   ```
3. Klik **Save**

---

## ▶️ Cara Run App

### Run di Android Emulator

```bash
# Pastikan emulator sudah jalan
flutter devices

# Run app
flutter run
```

### Run di iOS Simulator

```bash
# Buka simulator
open -a Simulator

# Run app
flutter run
```

### Run di Device Fisik

1. Enable **Developer Mode** dan **USB Debugging** di device
2. Hubungkan device via USB
3. Run:
   ```bash
   flutter run
   ```

### Build APK (Android)

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

File APK akan tersimpan di: `build/app/outputs/flutter-apk/`

---

## 🏗️ Struktur Project

```
lib/
├── main.dart                    # Entry point aplikasi
├── app.dart                     # Root widget & routing setup
├── core/
│   ├── config/
│   │   └── supabase_config.dart # Konfigurasi Supabase
│   ├── routing/
│   │   └── app_router.dart      # Routing & navigation
│   ├── theme/
│   │   └── app_theme.dart       # Global theme (Material 3)
│   └── widgets/
│       ├── primary_button.dart  # Reusable button
│       └── text_field.dart      # Reusable text field
├── data/
│   ├── repositories/
│   │   └── auth_repository.dart # Repository pattern untuk auth
│   └── services/
│       ├── supabase_client.dart # Supabase client singleton
│       └── auth_service.dart    # Authentication service
├── features/
│   ├── auth/
│   │   ├── login_page.dart      # Login screen
│   │   └── register_page.dart   # Register screen
│   └── profile/
│       └── create_profile_page.dart
└── state/
    └── auth_provider.dart       # Auth state management
```

---

## 👥 Tim Development

### Muhammad Iqbal Baiduri Yamani (5026221103)
**Tanggung Jawab:**
- ✅ Login & Register UI/UX (Figma implementation)
- ✅ Supabase Integration (authentication)
- ✅ App bootstrapping & routing
- ✅ Global theme (Material 3 dengan gradients)
- ✅ Google Sign In OAuth
- ✅ Project documentation

**File yang Dikerjakan:**
- `lib/main.dart`
- `lib/app.dart`
- `lib/core/theme/app_theme.dart`
- `lib/core/routing/app_router.dart`
- `lib/core/widgets/primary_button.dart`
- `lib/core/widgets/text_field.dart`
- `lib/data/services/supabase_client.dart`
- `lib/data/services/auth_service.dart`
- `lib/data/repositories/auth_repository.dart`
- `lib/features/auth/login_page.dart`
- `lib/features/auth/register_page.dart`
- `lib/features/profile/create_profile_page.dart`
- `lib/state/auth_provider.dart`
- `README.md`
- `.env.example`

---

## 🎨 Fitur yang Sudah Diimplementasi

### Authentication
- ✅ Login dengan Email & Password
- ✅ Register dengan Email & Password
- ✅ Google Sign In (OAuth 2.0)
- ✅ Deep linking untuk OAuth callback
- ✅ Create Profile setelah register

### UI/UX
- ✅ Material 3 Design System
- ✅ Gradient backgrounds (Navy blue theme)
- ✅ Gradient buttons dengan hover effects
- ✅ Custom text fields dengan external labels
- ✅ Responsive layouts
- ✅ App icon & splash screen

### Infrastructure
- ✅ Supabase integration
- ✅ State management (ChangeNotifier)
- ✅ Repository pattern
- ✅ Named routing
- ✅ Error handling

---

## 🔐 Security Notes

**PENTING:** Jangan commit file berikut ke Git:
- `.env` (credentials asli)
- `lib/secrets.dart` (jika ada)
- `android/app/google-services.json` (jika pakai Firebase)

File-file ini sudah ditambahkan ke `.gitignore`.

---

## 📱 Screenshots

<!-- Tambahkan screenshot aplikasi di sini -->

---

## 📝 License

Copyright © 2025 ReStock.in Team (by Kelompok 8 Teknologi Berkembang - B)

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/)
- [Supabase](https://supabase.com/)
- [Google Fonts](https://fonts.google.com/)
- [Material Design 3](https://m3.material.io/)

