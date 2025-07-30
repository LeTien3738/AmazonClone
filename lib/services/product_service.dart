import '../models/product.dart';

class ProductService {
  static final List<Product> _products = [
    Product(
      id: '1',
      name: 'iPhone 15 Pro Max',
      description: 'Apple iPhone 15 Pro Max với chip A17 Pro, camera 48MP, màn hình 6.7 inch Super Retina XDR OLED.',
      price: 29990000,
      originalPrice: 32990000,
      imageUrl: 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
      images: [
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
      ],
      category: 'Điện thoại',
      rating: 4.8,
      reviewCount: 1250,
      brand: 'Apple',
      features: [
        'Chip A17 Pro',
        'Camera 48MP',
        'Màn hình 6.7 inch',
        '5G',
        'Face ID',
      ],
    ),
    Product(
      id: '2',
      name: 'MacBook Air M2',
      description: 'MacBook Air với chip M2, màn hình 13.6 inch Liquid Retina, pin lên đến 18 giờ.',
      price: 25990000,
      originalPrice: 27990000,
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
      images: [
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
        'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400',
      ],
      category: 'Laptop',
      rating: 4.9,
      reviewCount: 890,
      brand: 'Apple',
      features: [
        'Chip M2',
        'Màn hình 13.6 inch',
        'Pin 18 giờ',
        'Thiết kế mỏng nhẹ',
        'macOS',
      ],
    ),
    Product(
      id: '3',
      name: 'Samsung Galaxy S24 Ultra',
      description: 'Samsung Galaxy S24 Ultra với S Pen tích hợp, camera 200MP, màn hình 6.8 inch Dynamic AMOLED.',
      price: 27990000,
      originalPrice: 29990000,
      imageUrl: 'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400',
      images: [
        'https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400',
        'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400',
      ],
      category: 'Điện thoại',
      rating: 4.7,
      reviewCount: 756,
      brand: 'Samsung',
      features: [
        'S Pen tích hợp',
        'Camera 200MP',
        'Màn hình 6.8 inch',
        '5G',
        'Android 14',
      ],
    ),
    Product(
      id: '4',
      name: 'AirPods Pro 2',
      description: 'AirPods Pro thế hệ 2 với chống ồn chủ động, âm thanh không gian, sạc không dây.',
      price: 5990000,
      originalPrice: 6990000,
      imageUrl: 'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
      images: [
        'https://images.unsplash.com/photo-1606220945770-b5b6c2c55bf1?w=400',
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
      ],
      category: 'Tai nghe',
      rating: 4.6,
      reviewCount: 432,
      brand: 'Apple',
      features: [
        'Chống ồn chủ động',
        'Âm thanh không gian',
        'Sạc không dây',
        'Tích hợp Siri',
        'Chống nước IPX4',
      ],
    ),
    Product(
      id: '5',
      name: 'iPad Air 5',
      description: 'iPad Air thế hệ 5 với chip M1, màn hình 10.9 inch Liquid Retina, hỗ trợ Apple Pencil.',
      price: 15990000,
      originalPrice: 17990000,
      imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
      images: [
        'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
        'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
      ],
      category: 'Máy tính bảng',
      rating: 4.8,
      reviewCount: 567,
      brand: 'Apple',
      features: [
        'Chip M1',
        'Màn hình 10.9 inch',
        'Apple Pencil 2',
        'Touch ID',
        'iPadOS',
      ],
    ),
    Product(
      id: '6',
      name: 'Sony WH-1000XM5',
      description: 'Tai nghe Sony WH-1000XM5 với chống ồn hàng đầu, âm thanh chất lượng cao.',
      price: 7990000,
      originalPrice: 8990000,
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=400',
      ],
      category: 'Tai nghe',
      rating: 4.9,
      reviewCount: 234,
      brand: 'Sony',
      features: [
        'Chống ồn hàng đầu',
        'Pin 30 giờ',
        'Sạc nhanh',
        'Điều khiển cảm ứng',
        'Bluetooth 5.2',
      ],
    ),
  ];

  static List<Product> getAllProducts() {
    return _products;
  }

  static List<Product> getProductsByCategory(String category) {
    return _products.where((product) => product.category == category).toList();
  }

  static List<Product> searchProducts(String query) {
    return _products.where((product) =>
        product.name.toLowerCase().contains(query.toLowerCase()) ||
        product.description.toLowerCase().contains(query.toLowerCase()) ||
        product.brand.toLowerCase().contains(query.toLowerCase())).toList();
  }

  static Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<String> getCategories() {
    return _products.map((product) => product.category).toSet().toList();
  }

  static List<Product> getFeaturedProducts() {
    return _products.where((product) => product.rating >= 4.5).toList();
  }

  static List<Product> getDiscountedProducts() {
    return _products.where((product) => product.hasDiscount).toList();
  }

  static void addProduct(Product product) {
    final newId = (int.tryParse(_products.isNotEmpty ? _products.last.id : '0') ?? 0) + 1;
    _products.add(product.copyWith(id: newId.toString()));
  }

  static void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  static void deleteProduct(String id) {
    _products.removeWhere((p) => p.id == id);
  }
} 