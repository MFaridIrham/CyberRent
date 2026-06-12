// Model untuk data pengguna (koleksi Firestore: users)

class UserModel {
  final String uid;
  final String name;
  final String email;
  final int balance;
  final String memberLevel;
  final int points;
  final String? photoBase64;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.balance,
    required this.memberLevel,
    required this.points,
    this.photoBase64,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      balance: (map['balance'] as num?)?.toInt() ?? 0,
      memberLevel: map['member_level'] as String? ?? 'Bronze',
      points: (map['points'] as num?)?.toInt() ?? 0,
      photoBase64: map['photo_base64'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'balance': balance,
      'member_level': memberLevel,
      'points': points,
      'photo_base64': photoBase64,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    int? balance,
    String? memberLevel,
    int? points,
    String? photoBase64,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      memberLevel: memberLevel ?? this.memberLevel,
      points: points ?? this.points,
      photoBase64: photoBase64 ?? this.photoBase64,
    );
  }
}
