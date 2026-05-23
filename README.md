# UpCycleHub - Flutter Frontend

Marketplace upcycling modern dengan Flutter + GetX + Firebase.

## 🚀 Cara Menjalankan

### 1. Prasyarat
- Flutter SDK >= 3.0.0
- Android Studio / VS Code
- Firebase project (Firestore aktif)

### 2. Setup Firebase
1. Buat project di [Firebase Console](https://console.firebase.google.com)
2. Aktifkan **Firestore Database** dan **Authentication**
3. Download `google-services.json` → taruh di `android/app/`
4. Download `GoogleService-Info.plist` → taruh di `ios/Runner/`
5. Jalankan `flutterfire configure` (opsional, untuk konfigurasi otomatis)

### 3. Setup Dependencies
```bash
flutter pub get
```

### 4. Konfigurasi API Base URL
Edit file `lib/app/data/providers/api_client.dart`:
```dart
static const String baseUrl = 'http://YOUR_API_URL/api';
```

### 5. Jalankan Aplikasi
```bash
flutter run
```

---

## 📁 Struktur Folder

```
lib/
├── main.dart
└── app/
    ├── data/
    │   ├── models/          # Data models (User, Product, Order, dll)
    │   ├── providers/       # API Client (Dio)
    │   └── repositories/    # Data layer
    ├── modules/
    │   ├── auth/            # Login & Register
    │   ├── home/            # Home & Main Navigation
    │   ├── product/         # List & Detail Produk
    │   ├── cart/            # Keranjang
    │   ├── checkout/        # Checkout & Upload Bukti
    │   ├── order/           # Riwayat & Detail Pesanan
    │   ├── review/          # Ulasan Produk
    │   ├── profile/         # Profil & Edit
    │   ├── seller/          # Dashboard & Manajemen Produk Seller
    │   ├── chat/            # Chat List & Chat Room (Firebase)
    │   └── notification/    # Notifikasi (Firebase)
    ├── routes/              # Routing GetX
    ├── services/            # Auth & Storage Service
    ├── themes/              # Light & Dark Theme
    ├── utils/               # Helper functions
    └── widgets/             # Reusable widgets
```

---

## 🎨 Fitur

### Buyer
- ✅ Login / Register (buyer & seller)
- ✅ Home dengan banner promo, produk featured & popular
- ✅ Filter kategori & search produk dengan debounce
- ✅ Detail produk (gallery, info seller, ulasan)
- ✅ Keranjang belanja
- ✅ Checkout dengan upload bukti pembayaran
- ✅ Riwayat & detail pesanan
- ✅ Tambah ulasan & rating
- ✅ Chat realtime dengan seller (Firebase Firestore)
- ✅ Notifikasi (Firebase Firestore)
- ✅ Edit profil & upload foto
- ✅ Dark/Light mode

### Seller
- ✅ Dashboard statistik (total produk, penjualan, revenue)
- ✅ CRUD produk + upload multiple foto
- ✅ Status verifikasi produk (pending/approved/rejected)
- ✅ Chat realtime dengan buyer

---

## 🔧 Teknologi

| Library | Kegunaan |
|---------|---------|
| GetX | State management, routing, DI |
| Dio | HTTP client + JWT interceptor |
| Firebase Firestore | Realtime chat & notifikasi |
| flutter_secure_storage | Penyimpanan JWT token |
| cached_network_image | Image caching |
| shimmer | Loading skeleton |
| google_fonts | Tipografi Poppins |
| image_picker | Upload foto |
| flutter_rating_bar | Rating bintang |

---

## 📡 API Endpoints

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | /register | Registrasi user |
| POST | /login | Login user |
| GET | /profile | Data profil |
| PUT | /profile | Update profil |
| GET | /products | List produk |
| GET | /products/:id | Detail produk |
| POST | /products | Tambah produk (seller) |
| PUT | /products/:id | Edit produk (seller) |
| DELETE | /products/:id | Hapus produk (seller) |
| GET | /categories | Daftar kategori |
| POST | /orders | Buat pesanan |
| GET | /orders | Riwayat pesanan |
| GET | /orders/:id | Detail pesanan |
| POST | /reviews | Tambah ulasan |
| GET | /reviews/:productId | Ulasan produk |

---

## 🔐 Demo Login

Gunakan tombol **"Demo Buyer"** atau **"Demo Seller"** di halaman login untuk langsung masuk tanpa registrasi (butuh backend).

Atau isi manual:
- **Buyer**: buyer@demo.com / password123
- **Seller**: seller@demo.com / password123

---

## 📝 Catatan

- Data dummy tersedia jika API tidak tersedia (lihat `ProductDummy`, `OrderDummy`, `ReviewDummy`)
- Firebase Firestore harus dikonfigurasi untuk fitur chat & notifikasi
- Pastikan mengganti `google-services.json` dengan file asli dari Firebase project kamu
