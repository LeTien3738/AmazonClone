import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart' as custom_search;
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _handleAddToCart(dynamic product) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      _showLoginDialog();
    } else {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.addItem(product);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm ${product.name} vào giỏ hàng'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng nhập cần thiết'),
          content: const Text('Bạn cần đăng nhập để thêm sản phẩm vào giỏ hàng.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Đăng nhập'),
            ),
          ],
        );
      },
    );
  }

  List<dynamic> _getFilteredProducts() {
    List<dynamic> products = ProductService.getAllProducts();
    
    if (_selectedCategory.isNotEmpty) {
      products = products.where((product) => product.category == _selectedCategory).toList();
    }
    
    if (_searchQuery.isNotEmpty) {
      products = ProductService.searchProducts(_searchQuery);
    }
    
    return products;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final categories = ProductService.getCategories();
    final featuredProducts = ProductService.getFeaturedProducts();
    final discountedProducts = ProductService.getDiscountedProducts();
    final filteredProducts = _getFilteredProducts();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          AppStrings.appName,
          style: AppTextStyles.heading2.copyWith(color: Colors.white),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                onPressed: () {
                  if (!authProvider.isAuthenticated) {
                    _showLoginDialog();
                  } else {
                    Navigator.of(context).pushNamed('/cart');
                  }
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          if (authProvider.isAuthenticated)
            PopupMenuButton<String>(
              icon: const Icon(Icons.person, color: Colors.white),
              onSelected: (value) {
                switch (value) {
                  case 'profile':
                    // Navigate to profile
                    break;
                  case 'logout':
                    authProvider.logout();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 8),
                      Text('Xin chào, ${authProvider.currentUser?.name ?? 'User'}'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      SizedBox(width: 8),
                      Text(AppStrings.logout),
                    ],
                  ),
                ),
              ],
            )
          else
            IconButton(
              icon: const Icon(Icons.login, color: Colors.white),
              onPressed: () => Navigator.of(context).pushNamed('/login'),
            ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Lịch sử đơn hàng',
            onPressed: () {
              Navigator.pushNamed(context, '/order-history');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingMedium),
              child: custom_search.SearchBar(
                controller: _searchController,
                onSearch: _onSearch,
                onClear: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
              ),
            ),

            // Login Banner (if not authenticated)
            if (!authProvider.isAuthenticated)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.paddingSmall),
                    Expanded(
                      child: Text(
                        'Đăng nhập để thêm sản phẩm vào giỏ hàng',
                        style: AppTextStyles.body2,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pushNamed('/login'),
                      child: Text(
                        'Đăng nhập',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Categories
            if (_searchQuery.isEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                child: Text(
                  AppStrings.categories,
                  style: AppTextStyles.heading3,
                ),
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () => _onCategorySelected(isSelected ? '' : category),
                      child: Container(
                        width: 100,
                        margin: const EdgeInsets.only(right: AppSizes.paddingMedium),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getCategoryIcon(category),
                              color: isSelected ? Colors.white : AppColors.primary,
                              size: 32,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category,
                              style: AppTextStyles.caption.copyWith(
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSizes.paddingLarge),
            ],

            // Search Results or Featured Products
            if (_searchQuery.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Kết quả tìm kiếm cho "$_searchQuery"',
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Featured Products
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 20,
                      color: Colors.amber,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.featured,
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: AppSizes.paddingSmall),
            
            // Products Grid
            if (filteredProducts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.all(AppSizes.paddingMedium),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.58, // Make cards taller for better display
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/product-detail',
                          arguments: product,
                        );
                      },
                      onAddToCart: () => _handleAddToCart(product),
                    );
                  },
                ),
              ),
            ] else ...[
              // No products found message
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingLarge),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingMedium),
                      Text(
                        'Không tìm thấy sản phẩm',
                        style: AppTextStyles.body1.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Hãy thử tìm kiếm với từ khóa khác',
                        style: AppTextStyles.body2,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Discounted Products
            if (_searchQuery.isEmpty && discountedProducts.isNotEmpty) ...[
              const SizedBox(height: AppSizes.paddingLarge),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.discount,
                      size: 20,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.deals,
                      style: AppTextStyles.heading3.copyWith(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.paddingSmall),
              SizedBox(
                height: 340, // Taller for better display
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium),
                  itemCount: discountedProducts.length,
                  itemBuilder: (context, index) {
                    final product = discountedProducts[index];
                    return Container(
                      width: 180,
                      margin: const EdgeInsets.only(right: 12),
                      child: ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            '/product-detail',
                            arguments: product,
                          );
                        },
                        onAddToCart: () => _handleAddToCart(product),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Điện thoại':
        return Icons.phone_android;
      case 'Laptop':
        return Icons.laptop;
      case 'Tai nghe':
        return Icons.headphones;
      case 'Máy tính bảng':
        return Icons.tablet_android;
      default:
        return Icons.category;
    }
  }
} 