# UTS APB - Rancangan Desain Aplikasi (Mind Map Visual)

## 📊 Struktur Hirarki Lengkap

```
UTS_APB
│
├─ 🏗️ ARSITEKTUR UI
│  ├─ Entry Point
│  │  ├─ MyApp (MaterialApp)
│  │  ├─ Dark Theme
│  │  └─ HomePage (Root)
│  │
│  ├─ Navigation Hub (HomePage)
│  │  ├─ StatefulWidget Pages
│  │  │  ├─ DetailPCPage (PC Rental Selection)
│  │  │  └─ OrderFoodPage (Food Ordering)
│  │  │
│  │  └─ StatelessWidget Pages
│  │     ├─ ProfilePage (Member Info)
│  │     ├─ CartPage (Shopping Cart)
│  │     ├─ BalancePage (Account Balance)
│  │     └─ PromoPage (Promotions)
│  │
│  └─ State Management
│     ├─ Cart (Global Singleton)
│     │  ├─ List<CartItem> items
│     │  ├─ ValueNotifier<int> totalNotifier
│     │  └─ Methods: addItem, getTotal, clear
│     │
│     └─ Page State
│        ├─ HomePage: ValueListener to Cart
│        ├─ DetailPCPage: selectedPC, hours, promo
│        └─ OrderFoodPage: Map<String, int> quantities
│
├─ 🌳 WIDGET TREE
│  ├─ HomePage (7 Sections)
│  │  ├─ AppBar
│  │  │  ├─ Leading: Balance Button (→ BalancePage)
│  │  │  └─ Actions: Cart Total (ValueListenableBuilder)
│  │  │
│  │  └─ Body: SingleChildScrollView
│  │     ├─ Welcome Section (Gradient Purple)
│  │     ├─ Promo Banner (→ PromoPage)
│  │     ├─ Service Menu (GridView 2x2)
│  │     │  ├─ Pilih PC (→ DetailPCPage)
│  │     │  ├─ Snack (→ OrderFoodPage)
│  │     │  ├─ Profil (→ ProfilePage)
│  │     │  └─ Bantuan (Placeholder)
│  │     ├─ Info Features (3 Items)
│  │     └─ Spacing
│  │
│  ├─ DetailPCPage
│  │  ├─ Header (Gradient Purple)
│  │  ├─ PC Options (Column)
│  │  │  ├─ PC Basic (Image + Info)
│  │  │  ├─ PC Pro (Image + Info)
│  │  │  └─ PC Ultra (Image + Info)
│  │  │
│  │  └─ If Selected:
│  │     ├─ Duration Slider (1-10 jam)
│  │     ├─ Promo Code TextField
│  │     └─ Add to Cart Button
│  │
│  ├─ OrderFoodPage
│  │  ├─ Header (Gradient Orange)
│  │  └─ Food GridView (2x2)
│  │     ├─ Indomie Spesial (Image + Counter + Order)
│  │     ├─ Nasi Goreng (Image + Counter + Order)
│  │     ├─ Ayam Bakar (Image + Counter + Order)
│  │     └─ Es Teh (Image + Counter + Order)
│  │
│  ├─ CartPage
│  │  ├─ Empty State (if empty)
│  │  ├─ Cart Items ListView
│  │  │  └─ Card Items (Name + Price + Qty + Subtotal)
│  │  │
│  │  └─ Bottom Section
│  │     ├─ Total Display
│  │     └─ Checkout Button
│  │
│  ├─ ProfilePage
│  │  ├─ Header Card (Cyan Gradient)
│  │  │  ├─ CircleAvatar (member_avatar.png)
│  │  │  ├─ Name & Email
│  │  │  └─ Level & Points
│  │  │
│  │  └─ Options Grid (2x3)
│  │     ├─ Login, Register, Edit Profil
│  │     └─ Riwayat, Pengaturan, Logout
│  │
│  └─ BalancePage
│     ├─ Balance Card (Gradient Cyan)
│     │  ├─ Saldo: Rp 100.000
│     │  └─ Top Up Button
│     │
│     └─ Transaction History (ListView)
│        ├─ Sewa PC Gaming Pro
│        ├─ Pesan Indomie Spesial
│        ├─ Top Up via QRIS
│        └─ Sewa PC Basic
│
├─ 🎨 PRINSIP LAYOUTING
│  ├─ Dark Mode Design
│  │  ├─ Background: #121212
│  │  ├─ Cards: #1E1E26
│  │  ├─ Accent: #00FFFF (Cyan)
│  │  ├─ Text Primary: #FFFFFF
│  │  └─ Text Secondary: #FFFFFF70
│  │
│  ├─ Gradient Styling
│  │  ├─ Purple (PC): purpleAccent → blueAccent
│  │  ├─ Orange (Food): orangeAccent → redAccent
│  │  ├─ Cyan (Profile): cyanAccent → blueAccent
│  │  └─ Direction: Top-Left → Bottom-Right
│  │
│  ├─ Responsive Grid Layout
│  │  ├─ Home Menu: GridView 2x2
│  │  ├─ Profile: GridView 2x3
│  │  ├─ Food Items: GridView 2x2
│  │  ├─ crossAxisSpacing: 10px
│  │  ├─ mainAxisSpacing: 10px
│  │  └─ shrinkWrap: true
│  │
│  ├─ Spacing System
│  │  ├─ Horizontal Padding: 16px
│  │  ├─ Vertical Margin: 10-20px
│  │  ├─ Card Margin: 16px all
│  │  ├─ Border Radius
│  │  │  ├─ Standard: 15px
│  │  │  ├─ Headers: 20px
│  │  │  └─ Images: 10px
│  │  └─ Consistent throughout
│  │
│  ├─ Card Design
│  │  ├─ Border Radius: 15px
│  │  ├─ Shadow: black26, blur 5, offset (0,2)
│  │  ├─ Normal State: #1E1E26 bg
│  │  ├─ Selected State: Cyan border + opacity 0.2
│  │  └─ Hover Effect: Enhanced cyan
│  │
│  ├─ Typography
│  │  ├─ Headline: 24px Bold
│  │  ├─ Title: 18px Bold
│  │  ├─ Subtitle: 16px Normal
│  │  ├─ Caption: 14px Normal
│  │  └─ Small: 12px Normal
│  │
│  └─ Interactive Elements
│     ├─ Button
│     │  ├─ Background: cyanAccent
│     │  ├─ Text: black
│     │  ├─ Padding: horizontal 50px, vertical 15px
│     │  └─ Radius: 10px
│     │
│     ├─ TextField
│     │  ├─ Fill: #2A2A3A
│     │  ├─ Border: Cyan 0.3 opacity
│     │  ├─ Focused Border: Cyan 2px
│     │  └─ Hint: white54
│     │
│     ├─ Slider
│     │  ├─ Active Color: Cyan
│     │  ├─ Min: 1, Max: 10
│     │  └─ Divisions: 9
│     │
│     └─ Notifications
│        └─ SnackBar: 2 seconds duration
│
├─ 🧭 ALUR NAVIGASI
│  ├─ Navigation Flow
│  │  ├─ MyApp → HomePage (Initial Route)
│  │  │
│  │  └─ HomePage (Hub)
│  │     ├─ AppBar.leading → BalancePage
│  │     ├─ AppBar.actions → CartPage
│  │     ├─ Menu[0] → DetailPCPage
│  │     ├─ Menu[1] → OrderFoodPage
│  │     ├─ Menu[2] → ProfilePage
│  │     ├─ Menu[3] → (Placeholder)
│  │     └─ Promo → PromoPage
│  │
│  ├─ Navigation Method
│  │  ├─ Navigator.push()
│  │  ├─ MaterialPageRoute
│  │  └─ Navigator.pop() return
│  │
│  └─ Cart Integration
│     ├─ DetailPCPage
│     │  ├─ Select PC & Duration
│     │  ├─ Add Promo Code (Optional)
│     │  ├─ Click "Tambah ke Keranjang"
│     │  ├─ Cart.addItem() executed
│     │  └─ SnackBar shown (2s)
│     │
│     ├─ OrderFoodPage
│     │  ├─ Adjust Item Qty
│     │  ├─ Click "Pesan"
│     │  ├─ Cart.addItem() executed
│     │  ├─ Quantity reset to 0
│     │  └─ SnackBar shown (2s)
│     │
│     └─ CartPage
│        ├─ View all items
│        ├─ Click "Checkout"
│        ├─ Cart.clear() executed
│        ├─ Success SnackBar (2s)
│        └─ pop() → HomePage
│
├─ 🔄 STATE MANAGEMENT
│  ├─ Cart Singleton Pattern
│  │  ├─ Properties
│  │  │  ├─ static List<CartItem> items
│  │  │  └─ static ValueNotifier<int> totalNotifier
│  │  │
│  │  └─ Methods
│  │     ├─ addItem(name, price, qty)
│  │     │  ├─ Check if item exists
│  │     │  ├─ Update quantity or add new
│  │     │  └─ Update totalNotifier
│  │     │
│  │     ├─ getTotal(): int
│  │     │  └─ Sum all (price × quantity)
│  │     │
│  │     └─ clear()
│  │        ├─ Clear items list
│  │        └─ Reset notifier = 0
│  │
│  └─ Page State Management
│     ├─ HomePage
│     │  ├─ Type: StatefulWidget
│     │  ├─ Listen: Cart.totalNotifier
│     │  ├─ Update: Keranjang AppBar display
│     │  └─ Builder: ValueListenableBuilder
│     │
│     ├─ DetailPCPage
│     │  ├─ Type: StatefulWidget
│     │  ├─ State: selectedPC, hours, promoCode
│     │  ├─ Controllers: promoController
│     │  └─ Action: Cart.addItem() on submit
│     │
│     ├─ OrderFoodPage
│     │  ├─ Type: StatefulWidget
│     │  ├─ State: Map<String, int> _quantities
│     │  ├─ Logic: Per-item independent counters
│     │  └─ Action: Cart.addItem() on Pesan
│     │
│     └─ Other Pages (Stateless)
│        ├─ ProfilePage (Display + Placeholder)
│        ├─ CartPage (Display + Checkout)
│        ├─ BalancePage (Display only)
│        └─ PromoPage (Display only)
│
└─ 🎯 DESIGN SYSTEM
   ├─ Color Palette
   │  ├─ Primary Dark: #121212
   │  ├─ Secondary Dark: #1E1E26
   │  ├─ Accent Cyan: #00FFFF
   │  ├─ Success Green: #4CAF50
   │  ├─ Warning Orange: #FF9800
   │  ├─ Error Red: #F44336
   │  └─ Highlight Purple: #9C27B0
   │
   ├─ Typography System
   │  ├─ Font Family: Default Material (Roboto)
   │  ├─ Sizes: 12px, 14px, 16px, 18px, 24px
   │  ├─ Weights: Normal (400), Medium (500), Bold (700)
   │  └─ Line Height: 1.5x
   │
   ├─ UI Components
   │  ├─ Scaffold
   │  │  ├─ backgroundColor: #121212
   │  │  └─ elevation: 0
   │  │
   │  ├─ AppBar (Transparent)
   │  │  ├─ Custom leading
   │  │  └─ Custom actions
   │  │
   │  ├─ Container (Gradient + Shadow)
   │  │  ├─ borderRadius: 15px
   │  │  ├─ BoxShadow applied
   │  │  └─ Gradient fill
   │  │
   │  ├─ GridView (Responsive)
   │  │  ├─ 2-column layout
   │  │  ├─ Auto spacing
   │  │  └─ shrinkWrap: true
   │  │
   │  ├─ ElevatedButton
   │  │  ├─ bg: cyanAccent
   │  │  └─ high contrast
   │  │
   │  ├─ TextField (Dark Mode)
   │  │  ├─ Cyan borders
   │  │  └─ Dark background
   │  │
   │  ├─ Image Assets
   │  │  ├─ Image.asset() method
   │  │  ├─ Rounded corners
   │  │  └─ BoxFit.cover
   │  │
   │  └─ CircleAvatar
   │     ├─ Member photo
   │     └─ AssetImage background
   │
   ├─ Spacing System
   │  ├─ xs: 4px (minor)
   │  ├─ s: 8px (small)
   │  ├─ m: 16px (standard)
   │  ├─ l: 20px (large)
   │  └─ xl: 24px (extra large)
   │
   └─ Shadow & Effects
      ├─ Color: black26
      ├─ Blur: 5px
      ├─ Offset: (0, 2)
      └─ Applied to all cards
```

---

## 📋 Ringkasan Komponen Utama

### Core Architecture
```
Entry: MyApp (MaterialApp)
   ↓
Hub: HomePage (StatefulWidget)
   ↓
├─ Pages with State: DetailPCPage, OrderFoodPage
├─ Display Pages: ProfilePage, CartPage, BalancePage, PromoPage
└─ Global State: Cart (Singleton + ValueNotifier)
```

### Key Features
- ✅ **Dark Mode**: Professional #121212 background
- ✅ **Responsive Grid**: 2x2, 2x3 layouts
- ✅ **Real-time Cart**: ValueListenableBuilder updates
- ✅ **Asset Images**: PC, Food, Member photos
- ✅ **Gradient Design**: Purple, Orange, Cyan
- ✅ **Smooth Navigation**: MaterialPageRoute
- ✅ **Interactive UI**: Sliders, TextFields, Buttons

### State Flow
```
User Action (Detail/Food Page)
   → Cart.addItem()
   → totalNotifier updated
   → ValueListenableBuilder listens
   → HomePage AppBar refreshed
   → Real-time display update
```

---

**Mind map ini mencakup semua aspek dari desain aplikasi UTS APB dengan struktur yang hirarki, rapi, dan mudah dipahami.**
