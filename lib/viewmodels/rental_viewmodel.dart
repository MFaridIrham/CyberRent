import 'package:flutter/foundation.dart';

import '../models/cart_item_model.dart';
import '../models/food_model.dart';
import '../models/pc_model.dart';

// ViewModel untuk mengatur katalog PC/Snack & keranjang belanja sebelum checkout
class RentalViewModel extends ChangeNotifier {
  // Katalog PC Gaming (sumber: detail_pc.dart)
  final List<PcModel> pcOptions = [
    PcModel(
      name: 'Gaming PC Basic',
      specs: 'RTX 3060, 16GB RAM, 144Hz Monitor',
      price: 12000,
      image: 'assets/pc_basic.png',
    ),
    PcModel(
      name: 'Gaming PC Pro',
      specs: 'RTX 4070, 32GB RAM, 240Hz Monitor',
      price: 18000,
      image: 'assets/pc_pro.png',
    ),
    PcModel(
      name: 'Gaming PC Ultra',
      specs: 'RTX 4090, 64GB RAM, 360Hz Monitor',
      price: 25000,
      image: 'assets/pc_ultra.png',
    ),
  ];

  // Katalog menu Snack (sumber: order_food.dart)
  final List<FoodModel> foodMenu = [
    FoodModel(name: 'Indomie Spesial', price: 15000, image: 'assets/indomie_spesial.png'),
    FoodModel(name: 'Nasi Goreng', price: 20000, image: 'assets/nasi_goreng.png'),
    FoodModel(name: 'Ayam Bakar', price: 25000, image: 'assets/ayam_bakar.png'),
    FoodModel(name: 'Es Teh', price: 5000, image: 'assets/es_teh.png'),
  ];

  // Keranjang belanja (state sementara sebelum checkout)
  final List<CartItemModel> _cartItems = [];
  List<CartItemModel> get cartItems => List.unmodifiable(_cartItems);

  int get totalPrice => _cartItems.fold(0, (sum, item) => sum + item.subtotal);

  // Create: tambah item PC/Snack ke keranjang
  void addItem(String name, int price, int quantity) {
    final index = _cartItems.indexWhere((item) => item.name == name);
    if (index >= 0) {
      _cartItems[index].quantity += quantity;
    } else {
      _cartItems.add(CartItemModel(name: name, price: price, quantity: quantity));
    }
    notifyListeners();
  }

  // Delete: hapus item dari keranjang
  void removeItem(String name) {
    _cartItems.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  // Update: ubah kuantitas item di keranjang (hapus otomatis jika <= 0)
  void updateQuantity(String name, int quantity) {
    final index = _cartItems.indexWhere((item) => item.name == name);
    if (index < 0) return;

    if (quantity <= 0) {
      _cartItems.removeAt(index);
    } else {
      _cartItems[index].quantity = quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
