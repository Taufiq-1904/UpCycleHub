class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final String? phone;
  final String? address;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    this.phone,
    this.address,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // Backend MySQL pakai 'id' (int), bukan '_id' (MongoDB ObjectId)
      // Tetap handle keduanya untuk safety
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['nama'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? 'pembeli').toString(),
      avatar: json['avatar']?.toString() ?? json['foto']?.toString(),
      phone: json['phone']?.toString() ?? json['telepon']?.toString(),
      address: json['address']?.toString() ?? json['alamat']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : json['created_at'] != null // MySQL biasanya pakai snake_case
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role,
        'avatar': avatar,
        'phone': phone,
        'address': address,
        'createdAt': createdAt?.toIso8601String(),
      };

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? avatar,
    String? phone,
    String? address,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      createdAt: createdAt,
    );
  }
}
