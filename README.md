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
├── main.dart                        # Entry point aplikasi
├── app.dart                         # Root widget & routing setup
├── core/
│   ├── config/
│   │   └── supabase_config.dart     # Konfigurasi Supabase
│   ├── routing/
│   │   └── app_router.dart          # Routing & navigation
│   ├── theme/
│   │   ├── app_theme.dart           # Global theme (Material 3)
│   │   └── app_colors.dart          # Color constants & gradients
│   ├── widgets/
│   │   ├── gradient_scaffold.dart   # Reusable gradient background
│   │   ├── primary_button.dart      # Reusable button
│   │   ├── text_field.dart          # Reusable text field
│   │   ├── loading_overlay.dart     # Loading indicator
│   │   └── card_tile.dart           # Card component
│   ├── constants/
│   │   ├── app_strings.dart         # String constants
│   │   └── app_sizes.dart           # Size constants
│   └── utils/
│       └── validators.dart          # Input validators
├── data/
│   ├── models/
│   │   ├── user_model.dart          # User data model
│   │   ├── store_model.dart         # Store data model
│   │   ├── item_model.dart          # Item data model
│   │   ├── cart_model.dart          # Cart data model
│   │   ├── invoice_model.dart       # Invoice data model
│   │   ├── payment_type_model.dart  # Payment type model
│   │   └── user_payment_type_model.dart # User payment method
│   ├── repositories/
│   │   ├── auth_repository.dart     # Auth repository
│   │   ├── profile_repository.dart  # Profile repository
│   │   ├── store_repository.dart    # Store repository
│   │   ├── payment_repository.dart  # Payment repository
│   │   ├── cart_repository.dart     # Cart repository
│   │   └── invoice_repository.dart  # Invoice repository
│   └── services/
│       ├── supabase_client.dart     # Supabase client singleton
│       ├── auth_service.dart        # Authentication service
│       ├── store_service.dart       # Store CRUD service
│       ├── payment_service.dart     # Payment service
│       ├── invoice_service.dart     # Invoice service
│       ├── cart_service.dart        # Cart service
│       └── user_service.dart        # User service
├── features/
│   ├── auth/
│   │   ├── login_page.dart          # Login screen
│   │   └── register_page.dart       # Register screen
│   ├── profile/
│   │   ├── create_profile_page.dart # Profile creation
│   │   ├── edit_profile_page.dart   # Edit profile
│   │   ├── profile_menu_page.dart   # Profile menu
│   │   ├── payment_methods_page.dart # Payment methods list
│   │   ├── add_payment_method_page.dart # Add payment method
│   │   └── change_password_page.dart # Change password
│   ├── payment/
│   │   ├── select_payment_page.dart # Select payment method
│   │   ├── input_payment_page.dart  # Input payment details
│   │   └── payment_success_page.dart # Payment method success
│   ├── role/
│   │   └── role_selection_page.dart # Role selection (Owner/Restocker)
│   ├── store_owner/
│   │   ├── my_store_page.dart       # My stores list
│   │   ├── create_store_page.dart   # Create new store
│   │   ├── edit_store_page.dart     # Edit store
│   │   └── add_store_items_page.dart # Add store items
│   ├── browse_store/
│   │   ├── stores_list_page.dart    # Browse stores (restocker)
│   │   └── store_detail_restock_page.dart # Store details
│   ├── restock/
│   │   ├── restock_invoice_preview_page.dart # Invoice preview
│   │   └── restock_proof_page.dart  # Upload restock proof
│   ├── invoices/
│   │   ├── invoices_tab_page.dart   # Invoice tabs
│   │   ├── invoice_detail_page.dart # Invoice details
│   │   └── payment_success_page.dart # Payment success
│   ├── home/
│   │   └── home_page.dart           # Home screen
│   └── settings/
│       └── logout_dialog.dart       # Logout confirmation
└── state/
    ├── auth_provider.dart           # Auth state management
    ├── profile_provider.dart        # Profile state
    ├── store_provider.dart          # Store state
    ├── payment_provider.dart        # Payment state
    ├── cart_provider.dart           # Cart state
    ├── invoiceprovider.dart         # Invoice state
    └── app_provider.dart            # App global state
```

---

## 👥 Tim Development

### Muhammad Iqbal Baiduri Yamani (5026221103)

**Tanggung Jawab:**

- ✅ Login & Register UI/UX (Figma implementation)
- ✅ Supabase Integration (Auth + Database + Storage)
- ✅ App bootstrapping & routing
- ✅ Global theme (Material 3 dengan gradients)
- ✅ Google Sign In OAuth
- ✅ Profile management (create, edit, image upload)
- ✅ Payment method system (9 payment types dengan logos)
- ✅ Store management (create, edit, list stores)
- ✅ Database schema design & RLS policies
- ✅ Navigation stack management
- ✅ Project documentation

---

### Ibrahim Amar Alfanani (5026231195)

**Tanggung Jawab:**

- ✅ add store item page,create store page,edit store page,mystore page (UI/UX Figma implementation)
- ✅ Supabase Integration (Database + Storage)
- ✅ Store management (create,read,update,delete)
- ✅ browse store(add fitur pencarian store)
- ✅ handling upload store image(formating,integration supabase storage)
- ✅ Database schema design & RLS policies
- ✅ implement database design (create database with postgresql in supabase)
- ✅ create indexing in db

---

## 🎨 Fitur yang Sudah Diimplementasi

### Authentication

- ✅ Login dengan Email & Password (Supabase Auth)
- ✅ Register dengan Email & Password (Supabase Auth)
- ✅ Google Sign In (OAuth 2.0)
- ✅ Deep linking untuk OAuth callback
- ✅ Auto-sync auth.users → public.users (trigger)
- ✅ Email-based user lookup
- ✅ Session management

### Profile & Payment

- ✅ Create Profile (nickname, description, profile image)
- ✅ Edit Profile
- ✅ Profile Menu
- ✅ Payment Method Management
- ✅ 9 Payment Types (Dana, Gopay, OVO, ShopeePay, Bank Mandiri, BCA, BNI, BRI, BSI)
- ✅ Payment method with logos
- ✅ Payment account details storage (JSON)

### Store Management (Store Owner)

- ✅ Create Store (name, address, store image)
- ✅ My Stores List
- ✅ Edit Store
- ✅ Add Store Items
- ✅ User-specific store loading (RLS)

### Browse & Restock (Restocker)

- ✅ Browse Stores List
- ✅ Store Details
- ✅ Restock Invoice Preview
- ✅ Upload Restock Proof

### Invoice Management

- ✅ Invoice Tabs (Incoming/Outgoing)
- ✅ Invoice Details
- ✅ Payment Success Screen
- ✅ Mark as Paid

### UI/UX

- ✅ Material 3 Design System
- ✅ Gradient backgrounds (Navy blue: #02173A → #032352)
- ✅ GradientScaffold widget for consistency
- ✅ Gradient buttons dengan hover effects
- ✅ Custom text fields dengan external labels
- ✅ Responsive layouts
- ✅ App icon & splash screen
- ✅ Loading overlays
- ✅ Card tile components

### Infrastructure

- ✅ Supabase integration (Auth + Database + Storage)
- ✅ State management (Provider pattern)
- ✅ Repository pattern
- ✅ Named routing dengan navigasi stack preservation
- ✅ Error handling
- ✅ Image upload (readAsBytes + uploadBinary)
- ✅ RLS policies (users, stores, user_payment_types)
- ✅ Storage buckets (profile-images, stores)

### Database Schema

- ✅ users (auth_user_id UUID, nickname, description, role, profile_image_url)
- ✅ stores (id_user FK, name, address, store_image_url)
- ✅ items (store_id FK, name, stock, price)
- ✅ payment_types (name, category: E-Wallet/Bank)
- ✅ user_payment_types (user_id FK, payment_type_id FK, payment_details JSON)
- ✅ carts (user_id FK, store_id FK)
- ✅ cart_items (cart_id FK, item_id FK, quantity)
- ✅ invoices (store_id FK, user_id FK, total_price, status)

---

## 🔐 Security Notes

**PENTING:** Jangan commit file berikut ke Git:

- `.env` (credentials asli)
- `lib/secrets.dart` (jika ada)
- `android/app/google-services.json` (jika pakai Firebase)

File-file ini sudah ditambahkan ke `.gitignore`.

---

## 📝 License

Copyright © 2025 ReStock.in Team (by Kelompok 8 Teknologi Berkembang - B)

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/)
- [Supabase](https://supabase.com/)
- [Google Fonts](https://fonts.google.com/)
- [Material Design 3](https://m3.material.io/)
