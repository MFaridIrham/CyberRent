// Model untuk item di dalam keranjang/pesanan (koleksi Firestore: orders.items)

class CartItemModel {
  final String name;
  final int price;
  int quantity;

  CartItemModel({
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'quantity': quantity,
    };
  }

  int get subtotal => price * quantity;
}

//halo