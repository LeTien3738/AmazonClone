# Amazon Clone - Flutter App

Một ứng dụng clone Amazon được xây dựng bằng Flutter với đầy đủ các tính năng cơ bản của một ứng dụng thương mại điện tử.

## 🚀 Tính năng

### 🔐 Xác thực người dùng
- **Đăng nhập**: Hệ thống đăng nhập với email và mật khẩu
- **Đăng ký**: Tạo tài khoản mới với thông tin cá nhân
- **Quản lý phiên**: Lưu trữ trạng thái đăng nhập

### 🏠 Trang chủ
- **Tìm kiếm sản phẩm**: Tìm kiếm theo tên, mô tả, thương hiệu
- **Danh mục sản phẩm**: Phân loại sản phẩm theo danh mục
- **Sản phẩm nổi bật**: Hiển thị các sản phẩm có đánh giá cao
- **Khuyến mãi**: Hiển thị sản phẩm giảm giá

### 📱 Chi tiết sản phẩm
- **Hình ảnh sản phẩm**: Gallery ảnh với chuyển đổi
- **Thông tin chi tiết**: Mô tả, thông số kỹ thuật, tính năng
- **Đánh giá**: Hiển thị rating và số lượng đánh giá
- **Giá cả**: Hiển thị giá gốc, giá khuyến mãi, phần trăm giảm
- **Thêm vào giỏ hàng**: Chọn số lượng và thêm vào giỏ

### 🛒 Giỏ hàng
- **Quản lý sản phẩm**: Thêm, xóa, cập nhật số lượng
- **Tính toán giá**: Tự động tính phí vận chuyển và thuế
- **Tóm tắt đơn hàng**: Hiển thị tổng tiền và chi tiết

### 💳 Thanh toán
- **Thông tin giao hàng**: Nhập địa chỉ và thông tin liên hệ
- **Phương thức thanh toán**: Nhiều lựa chọn thanh toán
- **Xác nhận đơn hàng**: Tóm tắt và xác nhận trước khi đặt

### ✅ Xác nhận đơn hàng
- **Thông báo thành công**: Hiển thị khi đặt hàng thành công
- **Thông tin đơn hàng**: Mã đơn hàng, ngày đặt, dự kiến giao
- **Theo dõi đơn hàng**: Hướng dẫn các bước tiếp theo

## 🛠️ Công nghệ sử dụng

- **Flutter**: Framework UI chính
- **Provider**: Quản lý state
- **Cached Network Image**: Tải và cache hình ảnh
- **HTTP**: Gọi API (chuẩn bị cho backend)
- **Shared Preferences**: Lưu trữ local

## 📱 Cài đặt và chạy

### Yêu cầu hệ thống
- Flutter SDK (phiên bản 3.8.1 trở lên)
- Dart SDK
- Android Studio / VS Code
- Android Emulator hoặc thiết bị thật

### Bước 1: Clone repository
```bash
git clone <repository-url>
cd cloneamazon
```

### Bước 2: Cài đặt dependencies
```bash
flutter pub get
```

### Bước 3: Chạy ứng dụng
```bash
flutter run
```

## 🎨 Giao diện

### Màu sắc chủ đạo
- **Primary**: #FF9900 (Cam Amazon)
- **Secondary**: #232F3E (Xanh đậm)
- **Background**: #F8F9FA (Xám nhạt)
- **Surface**: #FFFFFF (Trắng)

### Typography
- **Heading 1**: 24px, Bold
- **Heading 2**: 20px, Semi-bold
- **Heading 3**: 18px, Semi-bold
- **Body 1**: 16px, Regular
- **Body 2**: 14px, Regular
- **Caption**: 12px, Regular

## 📁 Cấu trúc dự án

```
lib/
├── models/           # Data models
│   ├── product.dart
│   ├── user.dart
│   └── cart_item.dart
├── providers/        # State management
│   ├── auth_provider.dart
│   └── cart_provider.dart
├── screens/          # UI screens
│   ├── login_screen.dart
│   ├── register_screen.dart
│   ├── home_screen.dart
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   └── order_success_screen.dart
├── widgets/          # Reusable widgets
│   ├── product_card.dart
│   └── search_bar.dart
├── services/         # Business logic
│   └── product_service.dart
├── utils/            # Utilities
│   └── constants.dart
└── main.dart         # App entry point
```

## 🔧 Cấu hình

### Demo Account
Để test ứng dụng, sử dụng tài khoản demo:
- **Email**: user@example.com
- **Password**: password

### Dữ liệu mẫu
Ứng dụng sử dụng dữ liệu mẫu bao gồm:
- 6 sản phẩm điện tử (iPhone, MacBook, Samsung, AirPods, iPad, Sony)
- 4 danh mục sản phẩm
- Hình ảnh từ Unsplash

## 🚀 Tính năng nâng cao (có thể phát triển)

- [ ] Backend API integration
- [ ] Push notifications
- [ ] Payment gateway integration
- [ ] Order tracking
- [ ] User reviews and ratings
- [ ] Wishlist functionality
- [ ] Product recommendations
- [ ] Multi-language support
- [ ] Dark mode
- [ ] Offline support

## 📝 License

Dự án này được tạo ra cho mục đích học tập và demo. Vui lòng không sử dụng cho mục đích thương mại.

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Vui lòng:
1. Fork dự án
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request

## 📞 Liên hệ

Nếu có bất kỳ câu hỏi nào, vui lòng tạo issue trên GitHub.

---

**Lưu ý**: Đây là một ứng dụng demo với dữ liệu mẫu. Trong môi trường production, bạn cần tích hợp với backend API thực tế và các dịch vụ thanh toán.
