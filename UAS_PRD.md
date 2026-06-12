# PRODUCT REQUIREMENT DOCUMENT (PRD)
## Pengembangan Aplikasi "CyberRent" (Upgrade UAS)

---

## 1. Ringkasan Eksekutif & Pendahulan

### 1.1 Latar Belakang Aplikasi
CyberRent adalah aplikasi mobile berbasis Flutter yang dirancang untuk mendigitalisasi ekosistem persewaan bilik/komputer di warnet modern (Cyber Cafe). Aplikasi ini mempermudah pengguna untuk memesan PC Gaming (berdasarkan spesifikasi dan durasi), memesan makanan/minuman langsung dari tempat duduk, serta memantau saldo digital mereka.

### 1.2 Target Objektif UAS
Mengubah aplikasi CyberRent yang sebelumnya berbasis *hardcoded/local state data* (UTS) menjadi aplikasi dinamis yang terintegrasi penuh dengan **Firebase Cloud Services**, menerapkan arsitektur **MVVM (Model-View-ViewModel)**, dan memiliki manajemen state yang terstruktur sesuai standar penilaian.

---

## 2. Fitur Utama & Kebutuhan Fungsional (UAS Scope)

Berdasarkan analisis berkas kode UTS, berikut adalah pemetaan fitur yang wajib diimplementasikan menggunakan **Firebase** untuk memenuhi kriteria nilai:

### 2.1 Manajemen Pengguna (Autentikasi & Sesi) — *Bobot 10%*
* **Sign Up & Sign In:** Menggunakan **Firebase Authentication** (Email & Password).
* **User Persistence / Sesi Aktif:** Aplikasi harus mendeteksi jika pengguna sudah masuk sebelumnya (tidak perlu login ulang saat aplikasi dibuka).
* **Informasi Profil Dinamis:** Menampilkan Nama Lengkap, Email, dan Tier Member (diambil secara dinamis dari Firebase Auth dan Firestore) pada `profile_page.dart`.

### 2.2 Operasi Basis Data (CRUD Online via Network) — *Bobot 20%*
Menggunakan **Cloud Firestore** sebagai basis data utama menggantikan tiruan data lokal pada `cart.dart` dan file pesanan.

* **Create (C):** Pengguna dapat memasukkan item sewa PC (`detail_pc.dart`) dan pesanan snack (`order_food.dart`) ke dalam Firestore (Keranjang Belanja/Pesanan Aktif). Proses *Checkout* pada `cart_page.dart` akan mengirimkan data pesanan final ke koleksi `orders`.
* **Read (R):** Menampilkan daftar riwayat transaksi secara dinamis pada `balance_page.dart` dari koleksi Firestore `transactions`.
* **Update (U):** Mengurangi saldo pengguna di database setelah melakukan pembayaran/checkout sukses.
* **Delete (D):** Pengguna dapat menghapus atau mengurangi kuantitas item dari dalam keranjang belanja sebelum checkout.

### 2.3 Antarmuka & Desain UI (Minimal 5 Halaman) — *Bobot 15%*
Aplikasi saat ini sudah memiliki UI struktur dasar dark-mode yang sangat baik. Halaman-halaman yang masuk dalam hitungan penilaian mencakup:
1. **Halaman Autentikasi (Baru):** Login & Register Page.
2. **Halaman Utama (`home_page.dart`):** Dashboard navigasi layanan.
3. **Halaman Sewa PC (`detail_pc.dart`):** Slider durasi, kode promo, dan daftar PC.
4. **Halaman Pesan Makanan (`order_food.dart`):** Menu snack dan kuantitas item.
5. **Halaman Keranjang (`cart_page.dart`):** Kalkulasi total harga dan aksi checkout.
6. **Halaman Saldo (`balance_page.dart`):** Kartu saldo dan list riwayat dinamis.
7. **Halaman Profil (`profile_page.dart`):** Informasi akun pengguna aktif.

---

## 3. Arsitektur Teknikal & Manajemen State — *Bobot 20%*

Untuk memenuhi standar arsitektur **MVVM** dan **State Management** yang bersih, struktur data global `ValueNotifier` pada file `cart.dart` saat UTS akan diubah mengikuti diagram berikut:
[ View ] <---> [ ViewModel (Provider) ] <---> [ Model (Firestore Data) ]
### 3.1 Stack Teknologi & Dependensi (`pubspec.yaml`)
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase Core & Services
  firebase_core: ^latest_version
  firebase_auth: ^latest_version
  cloud_firestore: ^latest_version

  # State Management
  provider: ^latest_version
  3.2 Struktur Folder Proyek (MVVM Pattern)
  lib/
│
├── models/
│   ├── user_model.dart
│   ├── pc_model.dart
│   ├── food_model.dart
│   └── cart_item_model.dart
│
├── viewmodels/
│   ├── auth_viewmodel.dart      # Mengatur alur login/register ke Firebase
│   ├── rental_viewmodel.dart    # Mengatur logika sewa PC & Snack
│   └── payment_viewmodel.dart   # Mengatur saldo & transaksi pengguna
│
└── views/
    ├── auth/
    │   ├── login_page.dart
    │   └── register_page.dart
    ├── home_page.dart
    ├── detail_pc.dart
    ├── order_food.dart
    ├── cart_page.dart
    └── balance_page.dart
    4. Skema Database (Firebase Firestore)
Berikut rancangan struktur koleksi NoSQL di Cloud Firestore untuk aplikasi CyberRent:

4.1 Koleksi: users
{
  "uid": "USER_AUTH_ID_123",
  "name": "Nama Lengkap Pengguna",
  "email": "user@example.com",
  "balance": 100000,
  "member_level": "Gold",
  "points": 1500
}
4.2 Koleksi: orders (Keranjang / Riwayat Transaksi)
{
  "order_id": "ORDER_67890",
  "uid": "USER_AUTH_ID_123",
  "items": [
    {
      "name": "Gaming PC Pro (3 jam)",
      "price": 54000,
      "quantity": 1
    },
    {
      "name": "Indomie Spesial",
      "price": 15000,
      "quantity": 2
    }
  ],
  "total_price": 84000,
  "timestamp": "2026-06-12T18:00:00Z"
}
Fitur,Skenario Pengujian,Hasil yang Diharapkan (Success Criteria)
Auth,Registrasi pengguna baru di halaman Register.,Data terbuat di Firebase Auth & dokumen pengguna baru muncul di Firestore users.
Persistence,"Keluar dari aplikasi tanpa logout, lalu buka kembali.",Aplikasi langsung mengarah ke HomePage tanpa meminta login ulang.
Create CRUD,Memilih PC atau Snack lalu menekan tombol pesan.,Item masuk ke keranjang belanja temporer atau tersimpan langsung di state Firestore.
Read CRUD,Membuka halaman balance_page.dart.,Riwayat transaksi menampilkan data real-time langsung dari dokumen Firestore milik pengguna.
Update/Delete,"Menekan tombol ""Checkout"" di keranjang.","Saldo berkurang otomatis di Firebase, keranjang kosong, dan dokumen pesanan bertambah di database."