import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../widgets/product_card.dart';
import '../utils/image_utils.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;

  void _handleAddToCart() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      _showLoginDialog();
    } else {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.addItem(widget.product, quantity: _quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đã thêm ${widget.product.name} vào giỏ hàng'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _handleBuyNow() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      _showLoginDialog();
    } else {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      cartProvider.addItem(widget.product, quantity: _quantity);
      Navigator.of(context).pushNamed('/checkout');
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

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final product = widget.product;
    final images = [product.imageUrl, ...product.images];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          product.name,
          style: AppTextStyles.body1.copyWith(color: Colors.white),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Images
            Container(
              height: 300,
              color: AppColors.surface,
              child: Column(
                children: [
                  // Main Image
                  Expanded(
                    child: PageView.builder(
                      itemCount: images.length,
                      onPageChanged: (index) {
                        setState(() {
                          _selectedImageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return ProductDetailImage(
                          imageUrl: images[index],
                        );
                      },
                    ),
                  ),
                  
                  // Image Indicators
                  if (images.length > 1)
                    Container(
                      padding: const EdgeInsets.all(AppSizes.paddingMedium),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedImageIndex == index
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Product Info
            Container(
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: AppTextStyles.heading1,
                  ),
                  
                  const SizedBox(height: AppSizes.paddingSmall),
                  
                  // Brand
                  if (product.brand.isNotEmpty)
                    Text(
                      'Thương hiệu: ${product.brand}',
                      style: AppTextStyles.body2,
                    ),
                  
                  const SizedBox(height: AppSizes.paddingMedium),
                  
                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        product.rating.toString(),
                        style: AppTextStyles.body1,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount} đánh giá)',
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.paddingMedium),
                  
                  // Price
                  Row(
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: AppTextStyles.price.copyWith(fontSize: 24),
                      ),
                      if (product.hasDiscount) ...[
                        const SizedBox(width: AppSizes.paddingMedium),
                        Text(
                          formatPrice(product.originalPrice),
                          style: AppTextStyles.originalPrice,
                        ),
                        const SizedBox(width: AppSizes.paddingSmall),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.discount,
                            borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                          ),
                          child: Text(
                            '-${product.discountPercentage.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Stock Status
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingMedium,
                      vertical: AppSizes.paddingSmall,
                    ),
                    decoration: BoxDecoration(
                      color: product.inStock ? AppColors.success : AppColors.error,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                    ),
                    child: Text(
                      product.inStock ? 'Còn hàng' : 'Hết hàng',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Quantity Selector
                  Row(
                    children: [
                      Text(
                        'Số lượng: ',
                        style: AppTextStyles.body1,
                      ),
                      const SizedBox(width: AppSizes.paddingMedium),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _quantity > 1
                                  ? () {
                                      setState(() {
                                        _quantity--;
                                      });
                                    }
                                  : null,
                            ),
                            Container(
                              width: 40,
                              alignment: Alignment.center,
                              child: Text(
                                _quantity.toString(),
                                style: AppTextStyles.body1,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Description
                  Text(
                    AppStrings.description,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),
                  Text(
                    product.description,
                    style: AppTextStyles.body1,
                  ),
                  
                  const SizedBox(height: AppSizes.paddingLarge),
                  
                  // Features
                  if (product.features.isNotEmpty) ...[
                    Text(
                      'Tính năng nổi bật',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSizes.paddingSmall),
                    ...product.features.map((feature) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: AppSizes.paddingSmall),
                          Expanded(
                            child: Text(
                              feature,
                              style: AppTextStyles.body1,
                            ),
                          ),
                        ],
                      ),
                    )),
                    const SizedBox(height: AppSizes.paddingLarge),
                  ],
                  
                  // Specifications
                  if (product.specifications.isNotEmpty) ...[
                    Text(
                      AppStrings.specifications,
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSizes.paddingSmall),
                    ...product.specifications.entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120,
                            child: Text(
                              '${entry.key}:',
                              style: AppTextStyles.body2.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              entry.value.toString(),
                              style: AppTextStyles.body2,
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppSizes.paddingMedium),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: product.inStock ? _handleAddToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                child: const Text(AppStrings.addToCart),
              ),
            ),
            const SizedBox(width: AppSizes.paddingMedium),
            Expanded(
              child: ElevatedButton(
                onPressed: product.inStock ? _handleBuyNow : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                child: const Text(AppStrings.buyNow),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 

// Custom widget for product detail images that removes watermarks
class ProductDetailImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const ProductDetailImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => Container(
                color: Colors.white,
                child: const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey.withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_not_supported_outlined,
                      color: Colors.grey[400],
                      size: 50,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Image not available',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Gradient overlay at the bottom for better visibility of controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 60,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom clipper that cuts off the right side where the watermark would be
class NoWatermarkClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Start at top-left
    path.moveTo(0, 0);
    // Line to top-right, but stop before the watermark area (80% of width)
    path.lineTo(size.width * 0.8, 0);
    // Line down to bottom-right at 80% width
    path.lineTo(size.width * 0.8, size.height);
    // Line to bottom-left
    path.lineTo(0, size.height);
    // Close the path
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
} 