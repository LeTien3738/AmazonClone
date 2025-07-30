import 'package:flutter/material.dart';

class AppColors {
  // Brand colors
  static const Color primary = Color(0xFFFF9900);
  static const Color primaryDark = Color(0xFFE08600);
  static const Color secondary = Color(0xFF232F3E);
  static const Color secondaryLight = Color(0xFF37475A);
  
  // UI colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Colors.white;
  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFE0E0E0);
  
  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  
  // Functional colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);
  
  // Special colors
  static const Color discount = Color(0xFFD32F2F);
  static const Color priceColor = Color(0xFFB12704);
  static const Color ratingColor = Color(0xFFFFA41C);
  static const Color prime = Color(0xFF00A8E1);
  static const Color buttonBackground = Color(0xFFFFD814);
  static const Color buttonText = Color(0xFF0F1111);
}

class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.3,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );
  
  // Body text
  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Special styles
  static const TextStyle price = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.priceColor,
    height: 1.2,
  );
  
  static const TextStyle originalPrice = TextStyle(
    fontSize: 14,
    decoration: TextDecoration.lineThrough,
    color: AppColors.textSecondary,
    height: 1.2,
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    color: AppColors.buttonText,
  );
  
  static const TextStyle link = TextStyle(
    fontSize: 14,
    color: Colors.blue,
    fontWeight: FontWeight.w500,
  );
}

class AppSizes {
  // Padding
  static const double paddingTiny = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  // Border radius
  static const double radiusSmall = 4.0;
  static const double radiusMedium = 8.0;
  static const double radiusLarge = 12.0;
  static const double radiusXLarge = 20.0;
  
  // Component sizes
  static const double buttonHeight = 48.0;
  static const double buttonHeightSmall = 36.0;
  static const double iconSize = 24.0;
  static const double iconSizeSmall = 18.0;
  static const double cardElevation = 2.0;
  
  // Product card
  static const double productCardImageHeight = 120.0;
  static const double productCardBorderRadius = 12.0;
}

class AppStrings {
  static const String appName = 'Amazon Clone';
  static const String searchHint = 'Tìm kiếm sản phẩm...';
  static const String addToCart = 'Thêm vào giỏ hàng';
  static const String buyNow = 'Mua ngay';
  static const String viewCart = 'Xem giỏ hàng';
  static const String checkout = 'Thanh toán';
  static const String login = 'Đăng nhập';
  static const String register = 'Đăng ký';
  static const String logout = 'Đăng xuất';
  static const String email = 'Email';
  static const String password = 'Mật khẩu';
  static const String name = 'Họ tên';
  static const String phone = 'Số điện thoại';
  static const String address = 'Địa chỉ';
  static const String categories = 'Danh mục';
  static const String featured = 'Sản phẩm nổi bật';
  static const String deals = 'Khuyến mãi';
  static const String reviews = 'Đánh giá';
  static const String description = 'Mô tả';
  static const String specifications = 'Thông số kỹ thuật';
  static const String relatedProducts = 'Sản phẩm liên quan';
  static const String total = 'Tổng cộng';
  static const String shipping = 'Phí vận chuyển';
  static const String tax = 'Thuế';
  static const String orderTotal = 'Tổng đơn hàng';
  static const String placeOrder = 'Đặt hàng';
  static const String orderSuccess = 'Đặt hàng thành công!';
  static const String orderFailed = 'Đặt hàng thất bại!';
  static const String emptyCart = 'Giỏ hàng trống';
  static const String emptyCartMessage = 'Bạn chưa có sản phẩm nào trong giỏ hàng';
  static const String continueShopping = 'Tiếp tục mua sắm';
  static const String remove = 'Xóa';
  static const String quantity = 'Số lượng';
  static const String subtotal = 'Tạm tính';
  static const String freeShipping = 'Miễn phí vận chuyển';
  static const String estimatedDelivery = 'Dự kiến giao hàng';
  static const String paymentMethod = 'Phương thức thanh toán';
  static const String creditCard = 'Thẻ tín dụng';
  static const String cashOnDelivery = 'Thanh toán khi nhận hàng';
  static const String bankTransfer = 'Chuyển khoản ngân hàng';
  static const String eWallet = 'Ví điện tử';
}

// App configuration
class AppConfig {
  static const bool showWatermarks = false; // Set to false to hide watermarks
}

String formatPrice(double price) {
  return '${price.toStringAsFixed(0).replaceAllMapped(
    RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
    (Match m) => '${m[1]},',
  )} ₫';
}

String formatDate(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
} 