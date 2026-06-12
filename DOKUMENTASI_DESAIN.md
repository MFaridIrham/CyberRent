# UTS APB - RANCANGAN DESAIN APLIKASI

## Daftar Isi
1. Arsitektur UI
2. Widget Tree
3. Prinsip Layouting
4. Alur Navigasi
5. State Management
6. Design System

---

## Arsitektur UI

### Struktur Aplikasi

Aplikasi dibangun di atas `MyApp` (MaterialApp) dengan tema Dark Mode berwarna `0xFF121212`. Titik masuk aplikasi adalah `HomePage`, yang terdiri dari dua bagian utama:

**Layer 1 - AppBar** memiliki dua tombol aksi:
- Bagian leading berupa tombol Saldo yang mengarah ke BalancePage
- Bagian actions berupa Cart Total (menggunakan ValueListenableBuilder) yang mengarah ke CartPage

**Layer 2-7 - Body Content** terdiri dari 7 bagian:
- Section 1: Banner Selamat Datang (dengan gradient)
- Section 2: Banner Promo (tap mengarah ke PromoPage)
- Section 3: Menu Layanan berupa GridView 2x2, meliputi: Pilih PC (ke DetailPCPage), Snack (ke OrderFoodPage), Profil (ke ProfilePage), dan Bantuan (placeholder)
- Section 4: Info Fitur (3 item)
- Section 5: Spacing
- Navigasi ke halaman lain: DetailPCPage (StatefulWidget), OrderFoodPage (StatefulWidget), ProfilePage (StatelessWidget), PromoPage (StatelessWidget), CartPage (StatelessWidget), dan BalancePage (StatelessWidget)

### Hubungan Antar Page

HomePage berfungsi sebagai hub yang menghubungkan ke berbagai halaman lain:

- **DetailPCPage** (Pilih PC Rental) → memanggil Cart.addItem()
- **OrderFoodPage** (Pesan Snack) → memanggil Cart.addItem()
- **ProfilePage** (Profile Member) → berisi aksi-aksi placeholder
- **CartPage** (Keranjang) → tombol Checkout memanggil Cart.clear()
- **BalancePage** (Saldo) → menampilkan riwayat transaksi
- **PromoPage** (Promosi) → menampilkan daftar promo

---

## Widget Tree

### HomePage Widget Tree

HomePage merupakan StatefulWidget berbentuk Scaffold dengan komponen:

**AppBar** (backgroundColor transparan, elevation 0):
- Leading berupa GestureDetector yang berisi Column dengan teks "Saldo" dan "Rp 100K"; ketika ditekan akan melakukan Navigator.push ke BalancePage
- Actions berupa ValueListenableBuilder yang berisi GestureDetector dan Column (memantau Cart.totalNotifier) dengan teks "Keranjang" dan nilai total; ketika ditekan akan melakukan Navigator.push ke CartPage

**Body** berupa SingleChildScrollView yang membungkus Column dengan isi:

1. **Section 1 - Welcome Container**: memiliki gradient (purpleAccent ke blueAccent), Icon fastfood berukuran 80, teks "CyberRent Cafe", dan teks "Sewa PC & Makan Snack"

2. **SizedBox** dengan tinggi 16

3. **Section 2 - Promo Banner**: Container dengan gradient cyan, GestureDetector, dan teks "DISKON 50% JAM KE-5"; ketika ditekan akan melakukan Navigator.push ke PromoPage

4. **SizedBox** dengan tinggi 16

5. **Section 3 - Service Menu** (GridView 2x2):
   - `_buildMenuButton` Pilih PC (warna purple), berisi Container bergradient, Icon, dan Text; ketika ditekan ke DetailPCPage
   - `_buildMenuButton` Snack (warna orange); ketika ditekan ke OrderFoodPage
   - `_buildMenuButton` Profil (warna cyan); ketika ditekan ke ProfilePage
   - `_buildMenuButton` Bantuan (warna green); ketika ditekan berupa placeholder

6. **SizedBox** dengan tinggi 16

7. **Section 4 - Info Features** (Column):
   - `_buildInfoItem` (⚡, Performa, Deskripsi) berupa Row yang berisi Text "⚡" (ukuran 32) dan Column (judul, deskripsi)
   - `_buildInfoItem` (💰, Harga, Deskripsi)
   - `_buildInfoItem` (🎮, Lengkap, Deskripsi)

8. **SizedBox** dengan tinggi 16

### DetailPCPage Widget Tree

DetailPCPage merupakan StatefulWidget dengan state: selectedPC, hours, promoCode, dan promoController. Strukturnya berupa Scaffold dengan:

**AppBar** (transparan) bertuliskan "Pilih PC"

**Body** berupa SingleChildScrollView yang membungkus Column dengan isi:

1. **Header Container** dengan gradient (purpleAccent ke blueAccent), Icon computer berukuran 80, teks "Pilih PC Gaming", dan teks "Sewa PC impian Anda"

2. **PC Options Column** berisi `_buildPCOption(pc)` sebanyak 3 kali, masing-masing berupa:
   - GestureDetector yang ketika ditekan akan melakukan setState(selectedPC = pc['name'])
   - Container berisi Row yang terdiri dari: Image.asset(pc['image']) dengan ukuran 80x80, borderRadius 10, dan fit BoxFit.cover; SizedBox lebar 16; Expanded Column dengan teks nama PC, spesifikasi, dan harga per jam; serta Icon check_circle (warna cyan) jika item terpilih

3. **Jika selectedPC sudah dipilih**, ditampilkan:
   - SizedBox tinggi 16
   - **Durasi Section**: teks "Durasi (Jam): $hours" dan Slider dengan value hours, rentang 1-10, activeColor cyanAccent, dan onChanged memanggil setState(hours = value)
   - SizedBox tinggi 16
   - Label "Kode Promo"
   - TextField dengan controller promoController, filled true, fillColor 0xFF2A2A3A, border cyan opacity 0.3, focusedBorder cyan 2px, hintText "Masukkan kode promo (opsional)", dan prefixIcon local_offer (cyan)
   - SizedBox tinggi 16
   - ElevatedButton "Tambah ke Keranjang" dengan backgroundColor cyanAccent, padding horizontal 50 vertical 15; ketika ditekan akan memanggil Cart.addItem(), menampilkan ScaffoldMessenger.showSnackBar(), promoController.clear(), dan setState(promoCode = "")

### OrderFoodPage Widget Tree

OrderFoodPage merupakan StatefulWidget dengan state berupa `_quantities: Map<String, int>`. Strukturnya berupa Scaffold dengan:

**AppBar** (transparan) bertuliskan "Snack Order"

**Body** berupa SingleChildScrollView yang membungkus Column dengan isi:

1. **Header Container** dengan gradient (orangeAccent ke redAccent), Icon fastfood berukuran 80, teks "Menu Snack", dan teks "Pilih snack favorit Anda"

2. **GridView.builder** (2x2) berisi `_buildFoodItem(item)` sebanyak 4 kali, dengan item: Indomie, Nasi Goreng, Ayam Bakar, dan Es Teh. Setiap item berupa Container dengan Column yang terdiri dari:
   - Image Container ukuran 100x100, borderRadius 15, berisi Image.asset (indomie_spesial.png, nasi_goreng.png, ayam_bakar.png, atau es_teh.png)
   - SizedBox tinggi 8
   - Teks nama (bold)
   - Teks harga
   - SizedBox tinggi 8
   - Quantity Counter Row: IconButton remove (memanggil setState qty-1), Text quantity, IconButton add (memanggil setState qty+1)
   - ElevatedButton "Pesan" dengan backgroundColor cyanAccent; jika quantity > 0, ketika ditekan akan memanggil Cart.addItem(), setState(qty = 0), dan showSnackBar()

3. **SizedBox** dengan tinggi 16

### CartPage Widget Tree

CartPage merupakan StatelessWidget berbentuk Scaffold dengan:

**AppBar** (transparan) bertuliskan "Keranjang"

**Body** berupa Column dengan kondisi:

- **Jika Cart.items kosong**: ditampilkan Expanded yang berisi Center dan Column dengan Icon shopping_cart_outlined serta teks "Keranjang kosong"

- **Jika tidak kosong**:
  - Expanded berisi ListView yang menampilkan Card CartItem sebanyak N, masing-masing berupa Container dengan padding 16, margin EdgeInsets.symmetric, borderRadius 15, dan Column berisi:
    - Row dengan teks nama item (bold), Spacer, dan teks "${quantity}x" (warna cyan)
    - SizedBox tinggi 8
    - Row dengan teks harga satuan, Spacer, dan teks total harga item (warna green)
  - Divider
  - Bottom Section berupa Padding dan Column berisi:
    - Row dengan teks "Total" (bold), Spacer, dan teks total harga keseluruhan (warna cyan, bold)
    - SizedBox tinggi 16
    - ElevatedButton "Checkout" dengan backgroundColor cyanAccent, lebar penuh; ketika ditekan akan memanggil Cart.clear(), menampilkan showSnackBar "Checkout berhasil", dan Navigator.pop()

### ProfilePage Widget Tree

ProfilePage merupakan StatelessWidget berbentuk Scaffold dengan:

**AppBar** (transparan) bertuliskan "Profil"

**Body** berupa SingleChildScrollView yang membungkus Column dengan isi:

1. **Header Card** berupa Container dengan gradient (cyanAccent ke blueAccent), borderRadius 20, dan Column berisi:
   - CircleAvatar dengan radius 50, backgroundImage AssetImage('assets/member_avatar.png'), backgroundColor white
   - SizedBox tinggi 10
   - Teks "Nama Member" (bold, ukuran 24)
   - Teks "member@example.com"
   - SizedBox tinggi 10
   - Teks "Level: Gold | Poin: 1500"

2. **SizedBox** tinggi 16

3. **Profile Options GridView** (2x3) berisi `_buildProfileOption` untuk masing-masing opsi: Login, Register, Edit Profil, Riwayat, Pengaturan, dan Logout. Setiap opsi berupa Container dan GestureDetector dengan icon bertinta, teks nama opsi, dan ketika ditekan akan menampilkan showSnackBar "Fitur Login..." (untuk contoh Login)

### BalancePage Widget Tree

BalancePage merupakan StatelessWidget berbentuk Scaffold dengan:

**AppBar** (transparan) bertuliskan "Saldo"

**Body** berupa SingleChildScrollView yang membungkus Column dengan isi:

1. **Balance Card** berupa Container dengan gradient (cyanAccent ke blueAccent), borderRadius 20, dan Column berisi:
   - Teks "Saldo Anda"
   - SizedBox tinggi 16
   - Teks "Rp 100.000" (bold, ukuran 32, warna cyan)
   - SizedBox tinggi 16
   - ElevatedButton "Top Up via QRIS" dengan backgroundColor white; ketika ditekan berupa placeholder

2. **SizedBox** tinggi 20

3. **Padding** berisi teks "Riwayat Transaksi" (bold)

4. **Transaction List** (ListView) berisi `_buildHistoryItem` sebanyak 4 kali untuk transaksi: Sewa PC, Indomie, dan Top Up. Setiap item berupa Container dengan Row berisi:
   - Column dengan teks judul (bold) dan teks tanggal (kecil)
   - Spacer
   - Teks jumlah, dengan warna green untuk Top Up (+Rp) dan warna red untuk pengeluaran (-Rp)

---

## Prinsip Layouting

### 1. Dark Mode Design System

**Palet Warna Utama:**
- Background Utama: `#121212` (Scaffold background)
- Background Card: `#1E1E26` (Container, Card)
- Accent Warna: `#00FFFF` (Cyan - Button, Icon, Border)
- Text Primary: `#FFFFFF`
- Text Secondary: `#FFFFFF70` (opacity 70%)

**Gradient Styling:**
- Purple (PC Rental): `purpleAccent → blueAccent` (kiri atas ke kanan bawah)
- Orange (Food/Snack): `orangeAccent → redAccent` (kiri atas ke kanan bawah)
- Cyan (Profile/Balance): `cyanAccent → blueAccent` (kiri atas ke kanan bawah)

### 2. Responsive Grid Layout

**GridView 2x2 (Menu Home):**
Susunan 2 kolom: baris pertama berisi Pilih PC dan Snack, baris kedua berisi Profil dan Bantuan. Pengaturan: CrossAxisCount 2, CrossAxisSpacing 10, MainAxisSpacing 10, childAspectRatio 1.0

**GridView 2x3 (Profile Options):**
Susunan 3 kolom 2 baris: baris pertama Login, Register, Edit Profil; baris kedua Riwayat, Pengaturan, Logout

**GridView 2x2 (Food Items):**
Susunan 2 kolom: baris pertama Indomie dan Nasi Goreng, baris kedua Ayam Bakar dan Es Teh

### 3. Spacing & Padding System

| Level | Pixel | Penggunaan |
|-------|-------|-----------|
| tiny | 4px | Spacing kecil |
| small | 8px | Antar elemen |
| medium | 16px | Padding/margin standar |
| large | 20px | Padding section |
| xlarge | 24px | Jarak antar section besar |

**Konsistensi:**
- Padding horizontal: 16px (EdgeInsets.symmetric(horizontal: 16))
- Margin vertikal antar section: 16px (SizedBox(height: 16))
- Margin card: 16px di semua sisi

### 4. Card & Container Design

**Border Radius:** 15px (standar), 20px (header section), 10px (gambar)

**Box Shadow:**
Menggunakan BoxShadow dengan warna black12, blurRadius 5, dan offset (0, 2)

**Interactive State:**
- Normal: background warna `Color(0xFF1E1E26)`
- Selected/Hover: `Colors.cyanAccent.withOpacity(0.2)` dengan border cyan

### 5. Typography System

| Level | Ukuran Font | Bobot | Penggunaan |
|-------|-------------|-------|-----------|
| Headline | 24px | Bold | Judul halaman, header section |
| Title | 18px | Bold | Judul card, subtitle |
| Subtitle | 16px | Normal | Teks isi, deskripsi |
| Caption | 14px | Normal | Teks sekunder, hint |
| Small | 12px | Normal | Metadata, timestamp |

### 6. Interactive Elements

**Buttons:**
- Background: `Colors.cyanAccent`
- Teks: `Colors.black`
- Padding: `EdgeInsets.symmetric(horizontal: 50, vertical: 15)`
- Border Radius: 10px

**Text Field:**
- Fill Color: `#2A2A3A`
- Border: cyan dengan opacity 0.3
- Focused Border: cyan lebar 2px
- Hint Style: `Colors.white54`

**Slider:**
- Active Color: `Colors.cyanAccent`
- Min/Max: 1-10 jam
- Divisions: 9

### 7. Scrollable Layout Pattern

**Semua halaman menggunakan `SingleChildScrollView`:**
- Mencegah overflow pada layar kecil
- Pengalaman scroll yang mulus
- Tinggi konten fleksibel

**Grid dengan `shrinkWrap: true` + `NeverScrollableScrollPhysics`:**
- Grid bersarang dalam SingleChildScrollView
- Mencegah double scroll

---

## Alur Navigasi

Alur dimulai dari [App Start] menuju MyApp (MaterialApp), kemudian ke HomePage sebagai entry point. Dari HomePage, terdapat beberapa jalur navigasi:

- **AppBar.leading** (tombol Saldo, ditekan) → BalancePage → pop() → kembali ke HomePage
- **AppBar.actions** (tombol Keranjang, ditekan) → CartPage → pop() → kembali ke HomePage
- **Menu[0]** (Pilih PC, ditekan) → DetailPCPage → pop() → kembali ke HomePage, dengan aksi "Add to Cart" yang memanggil Cart.addItem() dan menampilkan SnackBar
- **Menu[1]** (Snack, ditekan) → OrderFoodPage → pop() → kembali ke HomePage, dengan aksi "Pesan" yang memanggil Cart.addItem() dan menampilkan SnackBar
- **Menu[2]** (Profil, ditekan) → ProfilePage → pop() → kembali ke HomePage
- **Menu[3]** → Placeholder
- **Promo Banner** (Diskon Banner, ditekan) → PromoPage → pop() → kembali ke HomePage
- **CartPage Checkout** → Cart.clear() → menampilkan SnackBar → pop()

**Pattern Navigasi:**

Push menggunakan MaterialPageRoute:
```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => TargetPage())
);
```

Pop menggunakan:
```dart
Navigator.pop(context);
```

---

## State Management

### Cart System (Static Singleton)

Sistem Cart didefinisikan melalui dua class:

**CartItem** memiliki properti: name (String, final), price (int, final), dan quantity (int)

**Cart** memiliki:
- `items`: List<CartItem> static
- `totalNotifier`: ValueNotifier<int> static, diinisialisasi dengan nilai 0
- `addItem(String name, int price, int quantity)`: method static yang memperbarui item yang sudah ada atau menambahkan item baru, kemudian memperbarui nilai totalNotifier
- `getTotal()`: method static yang menghitung total dengan formula sum(price * quantity)
- `clear()`: method static yang mengosongkan items dan mereset totalNotifier.value menjadi 0

**Alur kerja:**
1. User menambahkan item di DetailPCPage/OrderFoodPage
2. Method Cart.addItem() dipanggil
3. Nilai Cart.totalNotifier diperbarui
4. ValueListenableBuilder pada HomePage melakukan rebuild
5. Tampilan Keranjang di AppBar otomatis terupdate

### Page State Management

| Page | Tipe | State | Fungsi |
|------|------|-------|--------|
| HomePage | StatefulWidget | (tidak ada) | Hub navigasi |
| DetailPCPage | StatefulWidget | selectedPC, hours, promoCode | Pemilihan PC & promo |
| OrderFoodPage | StatefulWidget | _quantities: Map | Counter item |
| ProfilePage | StatelessWidget | - | Tampilan saja |
| CartPage | StatelessWidget | - | Tampilan + Checkout |
| BalancePage | StatelessWidget | - | Tampilan saja |
| PromoPage | StatelessWidget | - | Tampilan saja |

---

## Design System Summary

### Color Palette

Aplikasi menggunakan kombinasi warna berikut:
- Primary Dark: `#121212` (Background)
- Secondary Dark: `#1E1E26` (Cards)
- Accent: `#00FFFF` (Cyan)
- Success: `#4CAF50` (Green)
- Warning: `#FF9800` (Orange)
- Error: `#F44336` (Red)
- Highlight: `#9C27B0` (Purple)

### Typography

Font family menggunakan Default Material (Roboto), dengan skala ukuran 12px, 14px, 16px, 18px, dan 24px, serta bobot Normal (400), Medium (500), dan Bold (700)

### Spacing

Sistem spacing terdiri dari 4px (xs), 8px (s), 16px (m), 20px (l), dan 24px (xl), digunakan secara konsisten di seluruh halaman

### Components

Komponen yang digunakan meliputi: AppBar (transparan, tanpa elevation), Container (dengan gradient, border-radius, dan shadow), GridView (layout responsif 2 kolom), GestureDetector (untuk feedback ketukan), ElevatedButton (warna cyan, kontras tinggi), TextField (gelap dengan border cyan), Slider (active track cyan), SnackBar (durasi 2 detik), Image.asset (sudut membulat), CircleAvatar (foto member), dan ValueListenableBuilder (UI reaktif)

---

## Widget Dependencies

Struktur dependensi antar file dalam folder `lib/` adalah sebagai berikut:

- **main.dart** (MyApp) — mengimpor home_page.dart
- **home_page.dart** (HomePage - HUB) — mengimpor detail_pc.dart, order_food.dart, profile_page.dart, promo_page.dart, cart_page.dart, balance_page.dart, dan cart.dart
- **detail_pc.dart** (DetailPCPage) — mengimpor cart.dart
- **order_food.dart** (OrderFoodPage) — mengimpor cart.dart
- **cart_page.dart** (CartPage) — mengimpor cart.dart
- **cart.dart** (Cart - State) — mengimpor foundation.dart (untuk ValueNotifier)
- **profile_page.dart** (ProfilePage) — berdiri sendiri (standalone)
- **balance_page.dart** (BalancePage) — berdiri sendiri (standalone)
- **promo_page.dart** (PromoPage) — berdiri sendiri (standalone)

---

## Diagram Plant UML

Lihat file: `RANCANGAN_DESAIN_APLIKASI.puml`

Untuk membuat diagram:
1. Buka file .puml melalui editor Plant UML online
2. Atau gunakan plugin IDE (PlantUML)

---

**Dokumentasi ini menjelaskan setiap aspek dari arsitektur UI, widget tree, dan prinsip layouting aplikasi UTS APB.**