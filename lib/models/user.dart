class User {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String? address;
  final String? avatar;
  final List<String> favorites;
  final List<String> cartItems;
  final bool isAdmin;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    this.address,
    this.avatar,
    this.favorites = const [],
    this.cartItems = const [],
    this.isAdmin = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      address: json['address'],
      avatar: json['avatar'],
      favorites: List<String>.from(json['favorites'] ?? []),
      cartItems: List<String>.from(json['cartItems'] ?? []),
      isAdmin: json['isAdmin'] == 1 || json['isAdmin'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'avatar': avatar,
      'favorites': favorites,
      'cartItems': cartItems,
      'isAdmin': isAdmin,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? phone,
    String? address,
    String? avatar,
    List<String>? favorites,
    List<String>? cartItems,
    bool? isAdmin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      favorites: favorites ?? this.favorites,
      cartItems: cartItems ?? this.cartItems,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
} 