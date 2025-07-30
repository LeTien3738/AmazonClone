import 'package:flutter/material.dart';
import '../models/order.dart';
import '../utils/constants.dart';
import 'package:intl/intl.dart';

class OrderDetailScreen extends StatelessWidget {
  final Order order;
  const OrderDetailScreen({super.key, required this.order});
  
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết đơn hàng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Mã đơn: #${order.id}', style: AppTextStyles.heading3),
            const SizedBox(height: 8),
            Text('Ngày đặt: ${_formatDate(order.orderDate)}'),
            Text('Dự kiến giao: ${_formatDate(order.deliveryDate)}'),
            Text('Trạng thái: ${order.status}'),
            const SizedBox(height: 8),
            Text('Địa chỉ giao hàng:', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
            Text(order.shippingAddress),
            const SizedBox(height: 8),
            Text('Phương thức thanh toán:', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
            Text(order.paymentMethod),
            if (order.note != null && order.note!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Ghi chú:', style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
              Text(order.note!),
            ],
            const Divider(height: 32),
            Text('Sản phẩm:', style: AppTextStyles.heading3),
            ...order.items.map((item) => ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('Số lượng: ${item.quantity}'),
                  trailing: Text('${item.product.price.toStringAsFixed(0)}đ'),
                )),
            const Divider(height: 32),
            Text('Tổng tiền: ${order.totalAmount.toStringAsFixed(0)}đ', style: AppTextStyles.heading3),
          ],
        ),
      ),
    );
  }
} 