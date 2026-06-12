// Model untuk data unit PC Gaming (sumber: detail_pc.dart)

class PcModel {
  final String name;
  final String specs;
  final int price;
  final String image;

  PcModel({
    required this.name,
    required this.specs,
    required this.price,
    required this.image,
  });

  factory PcModel.fromMap(Map<String, dynamic> map) {
    return PcModel(
      name: map['name'] as String? ?? '',
      specs: map['specs'] as String? ?? '',
      price: (map['price'] as num?)?.toInt() ?? 0,
      image: map['image'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'specs': specs,
      'price': price,
      'image': image,
    };
  }
}
