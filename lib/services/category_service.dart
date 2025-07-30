import '../models/category.dart';

class CategoryService {
  static final List<Category> _categories = [
    Category(
      id: '1',
      name: 'Điện thoại',
      description: 'Các loại điện thoại di động thông minh',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400',
    ),
    Category(
      id: '2',
      name: 'Laptop',
      description: 'Máy tính xách tay các loại',
      imageUrl: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400',
    ),
    Category(
      id: '3',
      name: 'Tai nghe',
      description: 'Tai nghe có dây và không dây',
      imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
    ),
    Category(
      id: '4',
      name: 'Máy tính bảng',
      description: 'Các loại máy tính bảng',
      imageUrl: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400',
    ),
  ];

  static List<Category> getAllCategories() {
    return _categories;
  }

  static Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static void addCategory(Category category) {
    final newId = (int.tryParse(_categories.isNotEmpty ? _categories.last.id : '0') ?? 0) + 1;
    _categories.add(category.copyWith(id: newId.toString()));
  }

  static void updateCategory(Category category) {
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index != -1) {
      _categories[index] = category;
    }
  }

  static void deleteCategory(String id) {
    _categories.removeWhere((c) => c.id == id);
  }
} 