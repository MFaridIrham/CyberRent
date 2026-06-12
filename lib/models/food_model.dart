// Model untuk data menu makanan/minuman (sumber: order_food.dart)

class FoodModel {
  final String name;
  final int price;
  final String image;

  FoodModel({
    required this.name,
    required this.price,
    required this.image,
  });

  factory FoodModel.fromMap(Map<String, dynamic> map) {
    return FoodModel(
      name: map['name'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      image: map['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'image': image,
    };
  }
}
