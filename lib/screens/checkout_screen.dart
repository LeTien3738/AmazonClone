import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _selectedPaymentMethod = AppStrings.cashOnDelivery;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
      _addressController.text = user.address ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isProcessing = true;
      });

      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        final orderProvider = Provider.of<OrderProvider>(context, listen: false);
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final user = authProvider.currentUser;
        final now = DateTime.now();
        final order = Order(
          id: now.millisecondsSinceEpoch.toString(),
          orderDate: now,
          deliveryDate: now.add(const Duration(days: 3)),
          items: List.from(cartProvider.items),
          totalAmount: cartProvider.totalAmount,
          status: 'Đang xử lý',
          shippingAddress: _addressController.text,
          paymentMethod: _selectedPaymentMethod,
          note: '',
        );
        await orderProvider.addOrder(order);
        cartProvider.clear();

        setState(() {
          _isProcessing = false;
        });

        Navigator.of(context).pushNamedAndRemoveUntil(
          '/order-success',
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final subtotal = cartProvider.totalAmount;
    final shipping = subtotal >= 500000 ? 0.0 : 30000.0;
    final tax = subtotal * 0.1;
    final total = subtotal + shipping + tax;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Thanh toán',
          style: AppTextStyles.heading2.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Shipping Information
            Container(
              margin: const EdgeInsets.all(AppSizes.paddingMedium),
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin giao hàng',
                      style: AppTextStyles.heading3,
                    ),
                    const SizedBox(height: AppSizes.paddingMedium),
                    
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppStrings.name,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập họ tên';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppSizes.paddingMedium),
                    
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: AppStrings.phone,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số điện thoại';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppSizes.paddingMedium),
                    
                    TextFormField(
                      controller: _addressController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppStrings.address,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa chỉ';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Payment Method
            Container(
              margin: const EdgeInsets.all(AppSizes.paddingMedium),
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.paymentMethod,
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.paddingMedium),
                  
                  _buildPaymentOption(
                    AppStrings.cashOnDelivery,
                    Icons.money,
                    'Thanh toán khi nhận hàng',
                  ),
                  _buildPaymentOption(
                    AppStrings.creditCard,
                    Icons.credit_card,
                    'Thẻ tín dụng/ghi nợ',
                  ),
                  _buildPaymentOption(
                    AppStrings.bankTransfer,
                    Icons.account_balance,
                    'Chuyển khoản ngân hàng',
                  ),
                  _buildPaymentOption(
                    AppStrings.eWallet,
                    Icons.account_balance_wallet,
                    'Ví điện tử (MoMo, ZaloPay)',
                  ),
                ],
              ),
            ),

            // Order Summary
            Container(
              margin: const EdgeInsets.all(AppSizes.paddingMedium),
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tóm tắt đơn hàng',
                    style: AppTextStyles.heading3,
                  ),
                  const SizedBox(height: AppSizes.paddingMedium),
                  
                  // Order Items
                  ...cartProvider.items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.paddingSmall),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            '${item.product.name} x${item.quantity}',
                            style: AppTextStyles.body2,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            formatPrice(item.totalPrice),
                            style: AppTextStyles.body2,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  )),
                  
                  const Divider(height: AppSizes.paddingLarge),
                  
                  // Summary
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.subtotal, style: AppTextStyles.body1),
                      Text(formatPrice(subtotal), style: AppTextStyles.body1),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.shipping, style: AppTextStyles.body2),
                      Text(
                        shipping == 0 ? AppStrings.freeShipping : formatPrice(shipping),
                        style: AppTextStyles.body2,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.paddingSmall),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.tax, style: AppTextStyles.body2),
                      Text(formatPrice(tax), style: AppTextStyles.body2),
                    ],
                  ),
                  const Divider(height: AppSizes.paddingLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.orderTotal,
                        style: AppTextStyles.heading3,
                      ),
                      Text(
                        formatPrice(total),
                        style: AppTextStyles.price.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Estimated Delivery
            Container(
              margin: const EdgeInsets.all(AppSizes.paddingMedium),
              padding: const EdgeInsets.all(AppSizes.paddingLarge),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.local_shipping,
                    color: AppColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: AppSizes.paddingMedium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.estimatedDelivery,
                          style: AppTextStyles.body1.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '2-3 ngày làm việc',
                          style: AppTextStyles.body2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space for bottom button
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
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _placeOrder,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
              ),
            ),
            child: _isProcessing
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    AppStrings.placeOrder,
                    style: AppTextStyles.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, IconData icon, String description) {
    return RadioListTile<String>(
      value: value,
      groupValue: _selectedPaymentMethod,
      onChanged: (newValue) {
        setState(() {
          _selectedPaymentMethod = newValue!;
        });
      },
      title: Row(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(width: AppSizes.paddingSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: AppTextStyles.body1,
                ),
                Text(
                  description,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ),
        ],
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
} 