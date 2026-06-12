# UTS APB - RANCANGAN DESAIN APLIKASI

## 📋 Daftar Isi
1. [Arsitektur UI](#arsitektur-ui)
2. [Widget Tree](#widget-tree)
3. [Prinsip Layouting](#prinsip-layouting)
4. [Alur Navigasi](#alur-navigasi)
5. [State Management](#state-management)
6. [Design System](#design-system)

---

## 🏗️ Arsitektur UI

### Struktur Aplikasi

```
MyApp (MaterialApp)
│
├── Theme: Dark Mode (0xFF121212)
│
└── HomePage (Entry Point)
    │
    ├── [LAYER 1] AppBar dengan 2 Action Button
    │   ├── Leading: Balance Button → BalancePage
    │   └── Actions: Cart Total (ValueListenableBuilder) → CartPage
    │
    └── [LAYER 2-7] Body Content (7 Sections)
        ├── Section 1: Welcome Banner (Gradient)
        ├── Section 2: Promo Banner (Tap → PromoPage)
        ├── Section 3: Service Menu (GridView 2x2)
        │   ├── Pilih PC → DetailPCPage
        │   ├── Snack → OrderFoodPage
        │   ├── Profil → ProfilePage
        │   └── Bantuan (Placeholder)
        ├── Section 4: Info Features (3 Items)
        ├── Section 5: Spacing
        └── Navigation to Other Pages:
            ├── DetailPCPage (StatefulWidget)
            ├── OrderFoodPage (StatefulWidget)
            ├── ProfilePage (StatelessWidget)
            ├── PromoPage (StatelessWidget)
            ├── CartPage (StatelessWidget)
            └── BalancePage (StatelessWidget)
```

### Hubungan Antar Page

```
HomePage (Hub)
    ↓
    ├──→ DetailPCPage (Pilih PC Rental)
    │        ↓
    │        └──→ Cart.addItem()
    │
    ├──→ OrderFoodPage (Pesan Snack)
    │        ↓
    │        └──→ Cart.addItem()
    │
    ├──→ ProfilePage (Profile Member)
    │        ↓
    │        └── Placeholder Actions
    │
    ├──→ CartPage (Keranjang)
    │        ↓
    │        └── Checkout → Cart.clear()
    │
    ├──→ BalancePage (Saldo)
    │        ↓
    │        └── Transaction History
    │
    └──→ PromoPage (Promosi)
             ↓
             └── Promo List
```

---

## 🌳 Widget Tree

### HomePage Widget Tree

```
HomePage (StatefulWidget)
│
└── Scaffold
    │
    ├── AppBar (backgroundColor: transparent, elevation: 0)
    │   │
    │   ├── leading: GestureDetector
    │   │   └── Column
    │   │       ├── Text("Saldo")
    │   │       └── Text("Rp 100K")
    │   │       [onTap] → Navigator.push(BalancePage)
    │   │
    │   └── actions: [ValueListenableBuilder]
    │       └── GestureDetector
    │           └── Column (listens to Cart.totalNotifier)
    │               ├── Text("Keranjang")
    │               └── Text("Rp ${value}")
    │               [onTap] → Navigator.push(CartPage)
    │
    └── body: SingleChildScrollView
        └── Column
            │
            ├── [Section 1] Welcome Container
            │   ├── gradient: LinearGradient(purpleAccent → blueAccent)
            │   ├── Icon(fastfood, size: 80)
            │   ├── Text("CyberRent Cafe")
            │   └── Text("Sewa PC & Makan Snack")
            │
            ├── SizedBox(height: 16)
            │
            ├── [Section 2] Promo Banner
            │   ├── Container(gradient: cyan)
            │   ├── GestureDetector
            │   └── Text("DISKON 50% JAM KE-5")
            │       [onTap] → Navigator.push(PromoPage)
            │
            ├── SizedBox(height: 16)
            │
            ├── [Section 3] Service Menu (GridView 2x2)
            │   ├── _buildMenuButton(Pilih PC, purple)
            │   │   └── Container(gradient) + Icon + Text
            │   │       [onTap] → Navigator.push(DetailPCPage)
            │   │
            │   ├── _buildMenuButton(Snack, orange)
            │   │   [onTap] → Navigator.push(OrderFoodPage)
            │   │
            │   ├── _buildMenuButton(Profil, cyan)
            │   │   [onTap] → Navigator.push(ProfilePage)
            │   │
            │   └── _buildMenuButton(Bantuan, green)
            │       [onTap] → Placeholder
            │
            ├── SizedBox(height: 16)
            │
            ├── [Section 4] Info Features (Column)
            │   ├── _buildInfoItem(⚡, Performa, Desc)
            │   │   └── Row
            │   │       ├── Text("⚡") [size: 32]
            │   │       └── Column(title, description)
            │   │
            │   ├── _buildInfoItem(💰, Harga, Desc)
            │   │
            │   └── _buildInfoItem(🎮, Lengkap, Desc)
            │
            └── SizedBox(height: 16)
```

### DetailPCPage Widget Tree

```
DetailPCPage (StatefulWidget)
│   state: selectedPC, hours, promoCode, promoController
│
└── Scaffold
    │
    ├── AppBar (transparent)
    │   └── title: "Pilih PC"
    │
    └── body: SingleChildScrollView
        └── Column
            │
            ├── Header Container
            │   ├── gradient: purpleAccent → blueAccent
            │   ├── Icon(computer, size: 80)
            │   ├── Text("Pilih PC Gaming")
            │   └── Text("Sewa PC impian Anda")
            │
            ├── PC Options Column
            │   └── _buildPCOption(pc) × 3
            │       ├── GestureDetector
            │       │   [onTap] → setState(selectedPC = pc['name'])
            │       │
            │       └── Container
            │           └── Row
            │               ├── Image.asset(pc['image'])
            │               │   ├── width: 80, height: 80
            │               │   ├── borderRadius: 10
            │               │   └── fit: BoxFit.cover
            │               │
            │               ├── SizedBox(width: 16)
            │               │
            │               ├── Expanded Column
            │               │   ├── Text(pc['name'])
            │               │   ├── Text(pc['specs'])
            │               │   └── Text("Rp ${pc['price']}/jam")
            │               │
            │               └── if isSelected:
            │                   └── Icon(check_circle, cyan)
            │
            └── if selectedPC != null:
                ├── SizedBox(height: 16)
                │
                ├── Durasi Section
                │   ├── Text("Durasi (Jam): $hours")
                │   └── Slider
                │       ├── value: hours.toDouble()
                │       ├── min: 1, max: 10
                │       ├── activeColor: cyanAccent
                │       └── onChanged → setState(hours = value)
                │
                ├── SizedBox(height: 16)
                │
                ├── Kode Promo Label
                │   └── Text("Kode Promo")
                │
                ├── TextField
                │   ├── controller: promoController
                │   ├── filled: true
                │   ├── fillColor: 0xFF2A2A3A
                │   ├── border: cyan (0.3 opacity)
                │   ├── focusedBorder: cyan (2px)
                │   ├── hintText: "Masukkan kode promo (opsional)"
                │   └── prefixIcon: local_offer (cyan)
                │
                ├── SizedBox(height: 16)
                │
                └── ElevatedButton (Tambah ke Keranjang)
                    ├── backgroundColor: cyanAccent
                    ├── padding: horizontal 50, vertical 15
                    ├── [onPressed]
                    │   ├── Cart.addItem()
                    │   ├── ScaffoldMessenger.showSnackBar()
                    │   ├── promoController.clear()
                    │   └── setState(promoCode = "")
                    └── child: Text("Tambah ke Keranjang", black)
```

### OrderFoodPage Widget Tree

```
OrderFoodPage (StatefulWidget)
│   state: _quantities: Map<String, int>
│
└── Scaffold
    │
    ├── AppBar (transparent)
    │   └── title: "Snack Order"
    │
    └── body: SingleChildScrollView
        └── Column
            │
            ├── Header Container
            │   ├── gradient: orangeAccent → redAccent
            │   ├── Icon(fastfood, size: 80)
            │   ├── Text("Menu Snack")
            │   └── Text("Pilih snack favorit Anda")
            │
            ├── GridView.builder (2x2)
            │   │
            │   └── _buildFoodItem(item) × 4
            │       │   [items: Indomie, Nasi Goreng, Ayam Bakar, Es Teh]
            │       │
            │       └── Container
            │           └── Column
            │               │
            │               ├── Image Container
            │               │   ├── width: 100, height: 100
            │               │   ├── borderRadius: 15
            │               │   └── Image.asset(item['image'])
            │               │       ├── indomie_spesial.png
            │               │       ├── nasi_goreng.png
            │               │       ├── ayam_bakar.png
            │               │       └── es_teh.png
            │               │
            │               ├── SizedBox(height: 8)
            │               │
            │               ├── Text(name, bold)
            │               │
            │               ├── Text("Rp ${price}")
            │               │
            │               ├── SizedBox(height: 8)
            │               │
            │               ├── Quantity Counter Row
            │               │   ├── IconButton(remove)
            │               │   │   └── setState(qty-1)
            │               │   ├── Text(quantity)
            │               │   └── IconButton(add)
            │               │       └── setState(qty+1)
            │               │
            │               └── ElevatedButton (Pesan)
            │                   ├── backgroundColor: cyanAccent
            │                   ├── [onPressed] if quantity > 0:
            │                   │   ├── Cart.addItem()
            │                   │   ├── setState(qty = 0)
            │                   │   └── showSnackBar()
            │                   └── child: Text("Pesan", black)
            │
            └── SizedBox(height: 16)
```

### CartPage Widget Tree

```
CartPage (StatelessWidget)
│
└── Scaffold
    │
    ├── AppBar (transparent)
    │   └── title: "Keranjang"
    │
    └── body: Column
        │
        ├── if Cart.items.isEmpty:
        │   └── Expanded
        │       └── Center
        │           └── Column
        │               ├── Icon(shopping_cart_outlined)
        │               └── Text("Keranjang kosong")
        │
        └── else:
            │
            ├── Expanded
            │   └── ListView
            │       └── CartItem Card × N
            │           └── Container
            │               ├── padding: 16
            │               ├── margin: EdgeInsets.symmetric
            │               ├── borderRadius: 15
            │               └── Column
            │                   ├── Row
            │                   │   ├── Text(item.name, bold)
            │                   │   ├── Spacer()
            │                   │   └── Text("${item.quantity}x", cyan)
            │                   │
            │                   ├── SizedBox(height: 8)
            │                   │
            │                   └── Row
            │                       ├── Text("Rp ${item.price}")
            │                       ├── Spacer()
            │                       └── Text("Rp ${item.price * item.quantity}", green)
            │
            ├── Divider
            │
            └── Bottom Section
                ├── Padding
                │   └── Column
                │       ├── Row
                │       │   ├── Text("Total", bold)
                │       │   ├── Spacer()
                │       │   └── Text("Rp ${Cart.getTotal()}", cyan, bold)
                │       │
                │       ├── SizedBox(height: 16)
                │       │
                │       └── ElevatedButton (Checkout)
                │           ├── backgroundColor: cyanAccent
                │           ├── width: full
                │           ├── [onPressed]
                │           │   ├── Cart.clear()
                │           │   ├── showSnackBar("Checkout berhasil")
                │           │   └── Navigator.pop()
                │           └── child: Text("Checkout", black)
```

### ProfilePage Widget Tree

```
ProfilePage (StatelessWidget)
│
└── Scaffold
    │
    ├── AppBar (transparent)
    │   └── title: "Profil"
    │
    └── body: SingleChildScrollView
        └── Column
            │
            ├── Header Card
            │   ├── Container
            │   ├── gradient: cyanAccent → blueAccent
            │   ├── borderRadius: 20
            │   └── Column
            │       │
            │       ├── CircleAvatar
            │       │   ├── radius: 50
            │       │   ├── backgroundImage: AssetImage('assets/member_avatar.png')
            │       │   └── backgroundColor: white
            │       │
            │       ├── SizedBox(height: 10)
            │       │
            │       ├── Text("Nama Member", bold, size: 24)
            │       │
            │       ├── Text("member@example.com")
            │       │
            │       ├── SizedBox(height: 10)
            │       │
            │       └── Text("Level: Gold | Poin: 1500")
            │
            ├── SizedBox(height: 16)
            │
            └── Profile Options GridView (2x3)
                │
                ├── _buildProfileOption(Login)
                │   └── Container + GestureDetector
                │       ├── tinted icon container
                │       ├── Text("Login")
                │       └── [onTap] → showSnackBar("Fitur Login...")
                │
                ├── _buildProfileOption(Register)
                │
                ├── _buildProfileOption(Edit Profil)
                │
                ├── _buildProfileOption(Riwayat)
                │
                ├── _buildProfileOption(Pengaturan)
                │
                └── _buildProfileOption(Logout)
```

### BalancePage Widget Tree

```
BalancePage (StatelessWidget)
│
└── Scaffold
    │
    ├── AppBar (transparent)
    │   └── title: "Saldo"
    │
    └── body: SingleChildScrollView
        └── Column
            │
            ├── Balance Card
            │   ├── Container
            │   ├── gradient: cyanAccent → blueAccent
            │   ├── borderRadius: 20
            │   └── Column
            │       ├── Text("Saldo Anda")
            │       ├── SizedBox(height: 16)
            │       ├── Text("Rp 100.000", bold, size: 32, cyan)
            │       ├── SizedBox(height: 16)
            │       └── ElevatedButton ("Top Up via QRIS")
            │           ├── backgroundColor: white
            │           └── [onPressed] → placeholder
            │
            ├── SizedBox(height: 20)
            │
            ├── Padding
            │   └── Text("Riwayat Transaksi", bold)
            │
            └── Transaction List (ListView)
                │
                └── _buildHistoryItem × 4
                    │   [Transaksi: Sewa PC, Indomie, Top Up]
                    │
                    └── Container
                        └── Row
                            ├── Column
                            │   ├── Text(title, bold)
                            │   └── Text(date, small)
                            │
                            ├── Spacer()
                            │
                            └── Text(amount)
                                ├── green: +Rp (Top Up)
                                └── red: -Rp (Spending)
```

---

## 🎨 Prinsip Layouting

### 1. Dark Mode Design System

**Palet Warna Utama:**
- **Background Utama**: `#121212` (Scaffold background)
- **Background Card**: `#1E1E26` (Container, Card)
- **Accent Warna**: `#00FFFF` (Cyan - Button, Icon, Border)
- **Text Primary**: `#FFFFFF`
- **Text Secondary**: `#FFFFFF70` (70% opacity)

**Gradient Styling:**
- **Purple (PC Rental)**: `purpleAccent → blueAccent` (TL to BR)
- **Orange (Food/Snack)**: `orangeAccent → redAccent` (TL to BR)
- **Cyan (Profile/Balance)**: `cyanAccent → blueAccent` (TL to BR)

### 2. Responsive Grid Layout

**GridView 2x2 (Home Menu):**
```
┌─────────────────────────────┐
│  Pilih PC  │    Snack      │
├─────────────────────────────┤
│  Profil    │   Bantuan     │
└─────────────────────────────┘
- CrossAxisCount: 2
- CrossAxisSpacing: 10
- MainAxisSpacing: 10
- childAspectRatio: 1.0
```

**GridView 2x3 (Profile Options):**
```
┌──────────────────────────────────┐
│  Login  │  Register  │ Edit Profil│
├──────────────────────────────────┤
│ Riwayat │ Pengaturan │  Logout   │
└──────────────────────────────────┘
```

**GridView 2x2 (Food Items):**
```
┌──────────────────────────┐
│ Indomie │ Nasi Goreng   │
├──────────────────────────┤
│ Ayam Bakar │ Es Teh      │
└──────────────────────────┘
```

### 3. Spacing & Padding System

| Level | Pixel | Usage |
|-------|-------|-------|
| tiny | 4px | Minor spacing |
| small | 8px | Between elements |
| medium | 16px | Standard padding/margin |
| large | 20px | Section padding |
| xlarge | 24px | Major section gaps |

**Konsistensi:**
- Horizontal padding: 16px (EdgeInsets.symmetric(horizontal: 16))
- Vertical margin antar section: 16px (SizedBox(height: 16))
- Card margin: 16px all sides

### 4. Card & Container Design

**Border Radius:** `15px` (standard), `20px` (header sections), `10px` (images)

**Box Shadow:**
```dart
BoxShadow(
  color: Colors.black12,
  blurRadius: 5,
  offset: Offset(0, 2)
)
```

**Interactive State:**
- Normal: `Color(0xFF1E1E26)` background
- Selected/Hover: `Colors.cyanAccent.withOpacity(0.2)` + cyan border

### 5. Typography System

| Level | Font Size | Weight | Usage |
|-------|-----------|--------|-------|
| Headline | 24px | Bold | Page title, section header |
| Title | 18px | Bold | Card title, subtitle |
| Subtitle | 16px | Normal | Body text, description |
| Caption | 14px | Normal | Secondary text, hint |
| Small | 12px | Normal | Metadata, timestamps |

### 6. Interactive Elements

**Buttons:**
- Background: `Colors.cyanAccent`
- Text: `Colors.black`
- Padding: `EdgeInsets.symmetric(horizontal: 50, vertical: 15)`
- Border Radius: `10px`

**Text Field:**
- Fill Color: `#2A2A3A`
- Border: Cyan with `0.3` opacity
- Focused Border: Cyan `2px` width
- Hint Style: `Colors.white54`

**Slider:**
- Active Color: `Colors.cyanAccent`
- Min/Max: 1-10 hours
- Divisions: 9

### 7. Scrollable Layout Pattern

**Semua halaman menggunakan `SingleChildScrollView`:**
- Mencegah overflow pada layar kecil
- Smooth scrolling experience
- Flexible height content

**Grid dengan `shrinkWrap: true` + `NeverScrollableScrollPhysics`:**
- Nested grid dalam SingleChildScrollView
- Prevents double scroll

---

## 🧭 Alur Navigasi

```
[App Start]
    ↓
MyApp → MaterialApp
    ↓
HomePage (Entry Point)
    │
    ├── [AppBar.leading] → BalancePage → pop() → HomePage
    │                      └─ [Tap] Balance button
    │
    ├── [AppBar.actions] → CartPage → pop() → HomePage
    │                      └─ [Tap] Keranjang button
    │
    ├── [Menu[0]] → DetailPCPage → pop() → HomePage
    │   │                └─ [Tap] Pilih PC
    │   └─ [Add to Cart] → Cart.addItem() → show SnackBar
    │
    ├── [Menu[1]] → OrderFoodPage → pop() → HomePage
    │   │                └─ [Tap] Snack
    │   └─ [Pesan] → Cart.addItem() → show SnackBar
    │
    ├── [Menu[2]] → ProfilePage → pop() → HomePage
    │                └─ [Tap] Profil
    │
    ├── [Menu[3]] → Placeholder
    │
    ├── [Promo Banner] → PromoPage → pop() → HomePage
    │                    └─ [Tap] Diskon Banner
    │
    └── [CartPage Checkout] → Cart.clear() → show SnackBar → pop()
```

**Navigation Pattern:**
```dart
// Push dengan MaterialPageRoute
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => TargetPage())
);

// Pop
Navigator.pop(context);
```

---

## 🔄 State Management

### Cart System (Static Singleton)

```dart
class CartItem {
  final String name;
  final int price;
  int quantity;
}

class Cart {
  static List<CartItem> items = [];
  static ValueNotifier<int> totalNotifier = ValueNotifier(0);
  
  static void addItem(String name, int price, int quantity)
    // Update item atau add new
    // Update totalNotifier.value
  
  static int getTotal()
    // Calculate total: sum(price * quantity)
  
  static void clear()
    // Clear items
    // Reset totalNotifier.value = 0
}
```

**Flow:**
1. User tambah item di DetailPCPage/OrderFoodPage
2. `Cart.addItem()` dipanggil
3. `Cart.totalNotifier.value` updated
4. HomePage `ValueListenableBuilder` rebuild
5. Keranjang display di AppBar terupdate otomatis

### Page State Management

| Page | Type | State | Purpose |
|------|------|-------|---------|
| HomePage | StatefulWidget | (none) | Navigation hub |
| DetailPCPage | StatefulWidget | selectedPC, hours, promoCode | PC selection & promo |
| OrderFoodPage | StatefulWidget | _quantities: Map | Item counters |
| ProfilePage | StatelessWidget | - | Display only |
| CartPage | StatelessWidget | - | Display + Checkout |
| BalancePage | StatelessWidget | - | Display only |
| PromoPage | StatelessWidget | - | Display only |

---

## 🎯 Design System Summary

### Color Palette
```
Primary Dark:     #121212 (Background)
Secondary Dark:   #1E1E26 (Cards)
Accent:          #00FFFF (Cyan)
Success:         #4CAF50 (Green)
Warning:         #FF9800 (Orange)
Error:           #F44336 (Red)
Highlight:       #9C27B0 (Purple)
```

### Typography
```
Font Family: Default Material (Roboto)
Scales: 12px, 14px, 16px, 18px, 24px
Weights: Normal (400), Medium (500), Bold (700)
```

### Spacing
```
4px (xs), 8px (s), 16px (m), 20px (l), 24px (xl)
Consistent throughout all pages
```

### Components
```
✓ AppBar (transparent, no elevation)
✓ Container (gradient, border-radius, shadow)
✓ GridView (responsive 2-column layout)
✓ GestureDetector (tap feedback)
✓ ElevatedButton (cyan, high contrast)
✓ TextField (dark, cyan border)
✓ Slider (cyan active track)
✓ SnackBar (2-second duration)
✓ Image.asset (rounded corners)
✓ CircleAvatar (member photo)
✓ ValueListenableBuilder (reactive UI)
```

---

## 📱 Widget Dependencies

```
lib/
├── main.dart (MyApp)
│   └── imports: home_page.dart
│
├── home_page.dart (HomePage - HUB)
│   ├── imports: detail_pc.dart
│   ├── imports: order_food.dart
│   ├── imports: profile_page.dart
│   ├── imports: promo_page.dart
│   ├── imports: cart_page.dart
│   ├── imports: balance_page.dart
│   └── imports: cart.dart
│
├── detail_pc.dart (DetailPCPage)
│   └── imports: cart.dart
│
├── order_food.dart (OrderFoodPage)
│   └── imports: cart.dart
│
├── cart_page.dart (CartPage)
│   └── imports: cart.dart
│
├── cart.dart (Cart - State)
│   └── imports: foundation.dart (ValueNotifier)
│
├── profile_page.dart (ProfilePage)
│   └── standalone
│
├── balance_page.dart (BalancePage)
│   └── standalone
│
└── promo_page.dart (PromoPage)
    └── standalone
```

---

## 📊 Diagram Plant UML

Lihat file: `RANCANGAN_DESAIN_APLIKASI.puml`

Untuk generate diagram:
1. Buka file .puml di Plant UML editor online
2. Atau gunakan IDE plugin (PlantUML)

---

**Dokumentasi ini menjelaskan setiap aspek dari arsitektur UI, widget tree, dan prinsip layouting aplikasi UTS APB.**
