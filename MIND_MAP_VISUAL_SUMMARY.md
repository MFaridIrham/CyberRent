# 🎯 UTS APB - RANCANGAN DESAIN APLIKASI
## Mind Map Visual & Dokumentasi Lengkap

---

## 📊 VISUAL HIERARCHY

```
┌─────────────────────────────────────────────────────────────────┐
│                          🚀 UTS APB                             │
│                   Cyber Rental Cafe Platform                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────┴─────────┐
                    │                   │
              📱 MyApp             📱 HomePage
           (MaterialApp)         (StatefulWidget)
              Dark Theme           HUB Center
                    │                   │
                    └─────────┬─────────┘
                              │
                ┌─────────────┼─────────────┐
                │             │             │
         ┌──────┴──────┐  ┌───┴────┐   ┌───┴─────┐
         │ Stateful    │  │ Global │   │Stateless│
         │ Pages (2)   │  │ State  │   │Pages (4)│
         │             │  │        │   │         │
         │ DetailPC    │  │ Cart   │   │ Profile │
         │ OrderFood   │  │        │   │ Cart    │
         │             │  │ Items  │   │ Balance │
         │             │  │ Total  │   │ Promo   │
         └─────────────┘  └────────┘   └─────────┘
                              ▲
                              │ ValueListenableBuilder
                              │ (Real-time Update)
```

---

## 🏗️ ARSITEKTUR APLIKASI

### Layer-by-Layer Structure

```
┌─────────────────────────────────────────────────────────┐
│  PRESENTATION LAYER                                     │
│  ┌──────────────────────────────────────────────────┐  │
│  │ HomePage (Hub)                                   │  │
│  │ • AppBar: Balance | Keranjang (Real-time)       │  │
│  │ • Body: 7 Sections                              │  │
│  │   - Welcome Banner                              │  │
│  │   - Promo Banner                                │  │
│  │   - Service Menu (GridView 2x2)                 │  │
│  │   - Info Features (3 Items)                     │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  FEATURE PAGES LAYER                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ DetailPC     │  │ OrderFood    │  │ Profile      │  │
│  │ (Stateful)   │  │ (Stateful)   │  │ (Stateless)  │  │
│  │              │  │              │  │              │  │
│  │ • Selection  │  │ • GridView   │  │ • Avatar     │  │
│  │ • Duration   │  │ • Counters   │  │ • Info       │  │
│  │ • Promo      │  │ • Order Btn  │  │ • Options    │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ Cart         │  │ Balance      │  │ Promo        │  │
│  │ (Stateless)  │  │ (Stateless)  │  │ (Stateless)  │  │
│  │              │  │              │  │              │  │
│  │ • Items List │  │ • Saldo      │  │ • List       │  │
│  │ • Total      │  │ • History    │  │ • Details    │  │
│  │ • Checkout   │  │ • TopUp      │  │              │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  STATE MANAGEMENT LAYER                                 │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Cart (Global Singleton)                         │  │
│  │ • static List<CartItem> items                   │  │
│  │ • static ValueNotifier<int> totalNotifier       │  │
│  │                                                 │  │
│  │ Methods:                                        │  │
│  │ • addItem(name, price, qty) → totalNotifier++  │  │
│  │ • getTotal() → sum(price × qty)                │  │
│  │ • clear() → reset items & notifier             │  │
│  └──────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  DESIGN SYSTEM LAYER                                    │
│  • Colors (Dark #121212, Cyan Accent)                   │
│  • Typography (24/18/16px)                              │
│  • Spacing (16px standard)                              │
│  • Components (Gradient, Cards, Buttons)                │
└─────────────────────────────────────────────────────────┘
```

---

## 🎨 DESIGN SYSTEM OVERVIEW

### Color Palette
```
Background:    #121212  ████████████ (Dark Black)
Card:          #1E1E26  ███████████░ (Dark Gray)
Accent:        #00FFFF  ▓▓▓▓▓▓▓▓▓▓▓▓ (Cyan - PRIMARY)

Gradient 1:    Purple → Blue     (DetailPC)
Gradient 2:    Orange → Red      (OrderFood)
Gradient 3:    Cyan → Blue       (Profile/Balance)

Success:       #4CAF50  ▓▓▓▓▓▓▓▓▓▓▓▓ (Green)
Warning:       #FF9800  ▓▓▓▓▓▓▓▓▓▓▓▓ (Orange)
Error:         #F44336  ▓▓▓▓▓▓▓▓▓▓▓▓ (Red)
```

### Typography Scale
```
Headline:      24px Bold      ← Page Titles
Title:         18px Bold      ← Card Titles
Subtitle:      16px Normal    ← Body Text
Caption:       14px Normal    ← Labels
Small:         12px Normal    ← Metadata
```

### Spacing System
```
xs (4px)   ▪ Minor spacing
s  (8px)   ▪ Between elements
m  (16px)  ▪▪ Standard padding
l  (20px)  ▪▪ Large sections
xl (24px)  ▪▪▪ Extra large gaps
```

---

## 🧩 WIDGET COMPOSITION PATTERN

### Container Blueprint
```
┌─────────────────────────────────────┐
│ Container                           │
│ ┌─────────────────────────────────┐ │
│ │ Gradient Fill                   │ │
│ │ ┌───────────────────────────┐   │ │
│ │ │ Padding: 16px            │   │ │
│ │ ┌───────────────────────────┐   │ │
│ │ │ Content (Text/Image/Row) │   │ │
│ │ └───────────────────────────┘   │ │
│ │ └─────────────────────────────┐ │
│ │ Border Radius: 15px             │ │
│ │ Box Shadow: black26 blur 5px    │ │
│ └─────────────────────────────────┘ │
│ Margin: 16px                        │
└─────────────────────────────────────┘
```

### Grid Layout Pattern
```
GridView (2 columns, 10px spacing)
┌────────────────────┬────────────────────┐
│    Card 1          │    Card 2          │
│  ┌──────────────┐  │  ┌──────────────┐  │
│  │ Image/Icon   │  │  │ Image/Icon   │  │
│  ├──────────────┤  │  ├──────────────┤  │
│  │ Title        │  │  │ Title        │  │
│  │ Description  │  │  │ Description  │  │
│  │ Button       │  │  │ Button       │  │
│  └──────────────┘  │  └──────────────┘  │
└────────────────────┴────────────────────┘
┌────────────────────┬────────────────────┐
│    Card 3          │    Card 4          │
│  ┌──────────────┐  │  ┌──────────────┐  │
│  │ Image/Icon   │  │  │ Image/Icon   │  │
│  ├──────────────┤  │  ├──────────────┤  │
│  │ Title        │  │  │ Title        │  │
│  │ Description  │  │  │ Description  │  │
│  │ Button       │  │  │ Button       │  │
│  └──────────────┘  │  └──────────────┘  │
└────────────────────┴────────────────────┘
```

---

## 📱 PAGE LAYOUT BREAKDOWN

### HomePage (Hub - 7 Sections)
```
┌─────────────────────────────────────┐
│ AppBar (Transparent)                │
│ ├─ Balance  [Rp 100K]       Cart    │
│ └─ (Leading)               [Rp Total] (Actions)
├─────────────────────────────────────┤
│ ScrollView                          │
│ ┌─────────────────────────────────┐ │
│ │ Welcome Section (Gradient)      │ │
│ │ 🎮 CyberRent Cafe              │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Promo Banner                    │ │
│ │ DISKON 50% JAM KE-5             │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Service Menu (GridView 2x2)     │ │
│ │ ┌──────────────┬──────────────┐ │ │
│ │ │ Pilih PC     │ Snack        │ │ │
│ │ ├──────────────┼──────────────┤ │ │
│ │ │ Profil       │ Bantuan      │ │ │
│ │ └──────────────┴──────────────┘ │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Info Features (3 Items)         │ │
│ │ ⚡ Performa | 💰 Harga | 🎮 Lengkap
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### DetailPCPage
```
┌─────────────────────────────────────┐
│ Header (Gradient Purple)            │
│ 💻 Pilih PC Gaming                 │
├─────────────────────────────────────┤
│ PC Options (Column Layout)          │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ [Img] PC Basic                  │ │
│ │       RTX 3060, 16GB, 144Hz     │ │
│ │       Rp 12.000/jam         ✓   │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ [Img] PC Pro                    │ │
│ │       RTX 4070, 32GB, 240Hz     │ │
│ │       Rp 18.000/jam             │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ [Img] PC Ultra                  │ │
│ │       RTX 4090, 64GB, 360Hz     │ │
│ │       Rp 25.000/jam             │ │
│ └─────────────────────────────────┘ │
│                                     │
│ IF SELECTED:                        │
│ ┌─────────────────────────────────┐ │
│ │ Durasi (Jam): 5                 │ │
│ │ ░░░░░●──────── [1 ────── 10]   │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Kode Promo (Optional)           │ │
│ │ [🏷️ Masukkan kode promo...]     │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ [Tambah ke Keranjang] (Cyan)    │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### CartPage
```
┌─────────────────────────────────────┐
│ Keranjang (AppBar)                  │
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ Gaming PC Basic (3 jam) - Promo │ │
│ │ Rp 12.000/jam × 3               │ │
│ │                      ➜ Rp 36.000 (🟢) │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Indomie Spesial × 2             │ │
│ │ Rp 15.000 × 2                   │ │
│ │                      ➜ Rp 30.000 (🟢) │
│ └─────────────────────────────────┘ │
│                                     │
│ ─────────────────────────────────── │
│                                     │
│ Total:                 Rp 66.000 (🔵) │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ [════ CHECKOUT ════] (Cyan)      │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

---

## 🔄 STATE FLOW DIAGRAM

### Real-time Cart Update Flow
```
[DetailPCPage]           [Cart]           [HomePage]
     │                    │                    │
     │ Click "Tambah"     │                    │
     ├──── addItem() ────→ │                    │
     │                    │ Update items[]     │
     │                    │ Update totalNotif. │
     │                    ├─────────ValueNotifier─────→│
     │                    │                    │ Rebuild
     │ SnackBar(2s)       │                    │ AppBar
     ├──────────(X)       │                    │ Cart total
     │                    │                    │
     └────pop()───────────────────────────→   │
                                               │
[OrderFoodPage]          [Cart]           [HomePage]
     │                    │                    │
     │ Click "Pesan"      │                    │
     ├──── addItem() ────→ │                    │
     │                    │ Update items[]     │
     │                    │ Update totalNotif. │
     │                    ├─────────ValueNotifier─────→│
     │                    │                    │ Rebuild
     │ SnackBar(2s)       │                    │ AppBar
     ├──────────(X)       │                    │
     │                    │                    │
     └────pop()───────────────────────────→   │

[CartPage]               [Cart]           [HomePage]
     │                    │                    │
     │ Click "Checkout"   │                    │
     ├──── clear() ──────→ │                    │
     │                    │ Clear items[]      │
     │                    │ totalNotif = 0     │
     │                    ├─────────ValueNotifier─────→│
     │                    │                    │ Rebuild
     │ SnackBar(2s)       │                    │ AppBar
     ├──────────(✓)       │                    │
     │                    │                    │
     └────pop()───────────────────────────→   │
                                   (Rp 0) 🟢
```

---

## 📋 KOMPONEN CHECKLIST

### Implemented ✅
- [x] Dark Mode Theme (#121212, #1E1E26)
- [x] HomePage (StatefulWidget, 7 sections)
- [x] DetailPCPage (3 PC options, slider, promo)
- [x] OrderFoodPage (4 food items, counters)
- [x] CartPage (checkout functionality)
- [x] ProfilePage (6 options)
- [x] BalancePage (4 transactions)
- [x] PromoPage (placeholder)
- [x] Cart Singleton (items, total, notifier)
- [x] ValueListenableBuilder (real-time update)
- [x] Asset Images (PC, Food, Avatar)
- [x] Gradient Styling (Purple, Orange, Cyan)
- [x] GridView Layouts (2x2, 2x3)
- [x] SnackBar Notifications (2 seconds)
- [x] Responsive Design

### Pending ⏳
- [ ] Login/Register Backend
- [ ] Promo Code Validation
- [ ] Top Up QRIS Integration
- [ ] Payment Gateway
- [ ] Database Synchronization

---

## 📚 FILE DOCUMENTATION

1. **RANCANGAN_DESAIN_APLIKASI.puml** - Plant UML diagram
2. **DOKUMENTASI_DESAIN.md** - Full detailed documentation
3. **MIND_MAP_LENGKAP.md** - Tree structure documentation
4. **RANCANGAN_DESAIN_MINDMAP.puml** - Mind map Plant UML format

---

## 🎯 QUICK REFERENCE

| Aspect | Details |
|--------|---------|
| **Framework** | Flutter (Dart) |
| **Theme** | Dark Mode with Cyan Accent |
| **Navigation** | Navigator.push() + MaterialPageRoute |
| **State** | Singleton Cart + ValueNotifier |
| **Grid Layout** | 2x2 (home), 2x3 (profile), 2x2 (food) |
| **Spacing** | 16px standard padding |
| **Typography** | 24/18/16px (headline/title/body) |
| **Components** | Gradient, Cards, Buttons, GridView |
| **Notifications** | SnackBar (2 seconds) |
| **Images** | Asset-based (PNG files) |

---

**Dokumentasi Lengkap ✅ - Ready for Development & Reference**
