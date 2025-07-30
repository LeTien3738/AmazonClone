import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';
import '../utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminRevenueManager extends StatefulWidget {
  const AdminRevenueManager({Key? key}) : super(key: key);

  @override
  State<AdminRevenueManager> createState() => _AdminRevenueManagerState();
}

class _AdminRevenueManagerState extends State<AdminRevenueManager> {
  String _selectedPeriod = 'Tháng này';
  final List<String> _periodOptions = ['Hôm nay', '7 ngày qua', 'Tháng này', '3 tháng qua', 'Năm nay'];
  
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<OrderProvider>(context, listen: false).loadOrders();
    });
  }

  String _formatCurrency(double amount) {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ', decimalDigits: 0);
    return formatter.format(amount);
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  DateTime _getStartDate() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case 'Hôm nay':
        return DateTime(now.year, now.month, now.day);
      case '7 ngày qua':
        return now.subtract(const Duration(days: 7));
      case 'Tháng này':
        return DateTime(now.year, now.month, 1);
      case '3 tháng qua':
        return DateTime(now.year, now.month - 2, 1);
      case 'Năm nay':
        return DateTime(now.year, 1, 1);
      default:
        return DateTime(now.year, now.month, 1);
    }
  }

  List<Order> _filterOrdersByPeriod(List<Order> orders) {
    final startDate = _getStartDate();
    return orders.where((order) => 
      order.orderDate.isAfter(startDate) || 
      order.orderDate.isAtSameMomentAs(startDate)
    ).toList();
  }

  Map<String, double> _calculateDailyRevenue(List<Order> orders) {
    final Map<String, double> dailyRevenue = {};
    
    for (final order in orders) {
      final dateStr = _formatDate(order.orderDate);
      if (dailyRevenue.containsKey(dateStr)) {
        dailyRevenue[dateStr] = dailyRevenue[dateStr]! + order.totalAmount;
      } else {
        dailyRevenue[dateStr] = order.totalAmount;
      }
    }
    
    return dailyRevenue;
  }

  double _calculateTotalRevenue(List<Order> orders) {
    return orders.fold(0, (sum, order) => sum + order.totalAmount);
  }

  int _countCompletedOrders(List<Order> orders) {
    return orders.where((order) => order.status == 'Đã giao').length;
  }

  int _countPendingOrders(List<Order> orders) {
    return orders.where((order) => order.status == 'Đang xử lý' || order.status == 'Đang giao').length;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final filteredOrders = _filterOrdersByPeriod(orderProvider.orders);
        final totalRevenue = _calculateTotalRevenue(filteredOrders);
        final completedOrders = _countCompletedOrders(filteredOrders);
        final pendingOrders = _countPendingOrders(filteredOrders);
        final dailyRevenue = _calculateDailyRevenue(filteredOrders);
        
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Thống kê doanh thu', style: AppTextStyles.heading2),
              const SizedBox(height: 16),
              
              // Period selector
              DropdownButtonFormField<String>(
                value: _selectedPeriod,
                decoration: InputDecoration(
                  labelText: 'Khoảng thời gian',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                ),
                items: _periodOptions.map((period) {
                  return DropdownMenuItem(
                    value: period,
                    child: Text(period),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedPeriod = value;
                    });
                  }
                },
              ),
              
              const SizedBox(height: 24),
              
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      'Tổng doanh thu',
                      _formatCurrency(totalRevenue),
                      Icons.attach_money,
                      AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Đơn hàng hoàn thành',
                      completedOrders.toString(),
                      Icons.check_circle,
                      AppColors.info,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSummaryCard(
                      'Đơn hàng đang xử lý',
                      pendingOrders.toString(),
                      Icons.pending_actions,
                      AppColors.warning,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Chart
              if (dailyRevenue.isNotEmpty) ...[
                Text('Biểu đồ doanh thu', style: AppTextStyles.heading3),
                const SizedBox(height: 16),
                Container(
                  height: 300,
                  padding: const EdgeInsets.all(16),
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
                  child: _buildRevenueChart(dailyRevenue),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Recent orders
              Text('Đơn hàng gần đây', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              
              Expanded(
                child: ListView.builder(
                  itemCount: filteredOrders.length > 5 ? 5 : filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = filteredOrders[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text('Mã đơn: #${order.id}'),
                        subtitle: Text('Ngày: ${_formatDate(order.orderDate)}'),
                        trailing: Text(
                          _formatCurrency(order.totalAmount),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Text(title, style: AppTextStyles.body2),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading3.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart(Map<String, double> dailyRevenue) {
    final sortedDates = dailyRevenue.keys.toList()
      ..sort((a, b) => DateFormat('dd/MM/yyyy').parse(a).compareTo(DateFormat('dd/MM/yyyy').parse(b)));
    
    final spots = <FlSpot>[];
    for (var i = 0; i < sortedDates.length; i++) {
      spots.add(FlSpot(i.toDouble(), dailyRevenue[sortedDates[i]]!));
    }

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitles: (value) {
              final index = value.toInt();
              if (index >= 0 && index < sortedDates.length) {
                final date = DateFormat('dd/MM/yyyy').parse(sortedDates[index]);
                return DateFormat('dd/MM').format(date);
              }
              return '';
            },
          ),
          leftTitles: SideTitles(
            showTitles: true,
            reservedSize: 60,
            getTitles: (value) {
              if (value == 0) return '0';
              if (value >= 1000000) {
                return '${(value / 1000000).toStringAsFixed(0)}M';
              }
              return '${(value / 1000).toStringAsFixed(0)}K';
            },
          ),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: (sortedDates.length - 1).toDouble(),
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            colors: [AppColors.primary],
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              colors: [AppColors.primary.withOpacity(0.2)],
            ),
          ),
        ],
      ),
    );
  }
}