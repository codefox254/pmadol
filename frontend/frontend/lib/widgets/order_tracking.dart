// ============================================
// lib/widgets/order_tracking.dart
// Order Tracking and Status Widget
// ============================================
import 'package:flutter/material.dart';
import '../models/shop_models.dart';
import '../config/api_config.dart';

class OrderTrackingWidget extends StatelessWidget {
  final Order order;

  const OrderTrackingWidget({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Header
        _buildOrderHeader(),
        const SizedBox(height: 24),

        // Status Timeline
        _buildStatusTimeline(),
        const SizedBox(height: 24),

        // Delivery Details
        _buildDeliveryDetails(),
        const SizedBox(height: 24),

        // Items List
        _buildOrderItems(),
        const SizedBox(height: 24),

        // Payment Information
        _buildPaymentInfo(),
      ],
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Number',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF707781),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                      fontFamily: 'Courier',
                    ),
                  ),
                ],
              ),
              _buildStatusBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Date',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF707781),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(order.createdAt),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Expected Delivery',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF707781),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order.estimatedDelivery != null
                        ? _formatDate(order.estimatedDelivery!)
                        : 'TBD',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color statusColor;
    IconData statusIcon;

    switch (order.status) {
      case 'pending':
        statusColor = const Color(0xFFFCD34D);
        statusIcon = Icons.schedule;
        break;
      case 'processing':
        statusColor = const Color(0xFF60A5FA);
        statusIcon = Icons.update;
        break;
      case 'shipped':
        statusColor = const Color(0xFF34D399);
        statusIcon = Icons.local_shipping;
        break;
      case 'in_transit':
        statusColor = const Color(0xFF34D399);
        statusIcon = Icons.directions_car;
        break;
      case 'delivered':
        statusColor = const Color(0xFF10B981);
        statusIcon = Icons.check_circle;
        break;
      case 'cancelled':
        statusColor = const Color(0xFFEF4444);
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = const Color(0xFF707781);
        statusIcon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusIcon, size: 14, color: statusColor),
          const SizedBox(width: 6),
          Text(
            order.statusDisplay,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTimeline() {
    final statuses = [
      ('Order Placed', order.status != 'pending', Icons.check_circle),
      ('Processing', ['processing', 'shipped', 'in_transit', 'delivered', 'cancelled']
              .contains(order.status),
          Icons.update),
      ('Shipped', ['shipped', 'in_transit', 'delivered'].contains(order.status),
          Icons.local_shipping),
      ('In Transit', ['in_transit', 'delivered'].contains(order.status),
          Icons.directions_car),
      ('Delivered', order.status == 'delivered', Icons.check_circle),
    ];

    return Column(
      children: [
        for (int i = 0; i < statuses.length; i++)
          Column(
            children: [
              Row(
                children: [
                  // Timeline dot
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statuses[i].$2
                          ? const Color(0xFF5886BF)
                          : const Color(0xFFE5E7EB),
                    ),
                    child: Icon(
                      statuses[i].$3,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Status text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statuses[i].$1,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: statuses[i].$2
                                ? const Color(0xFF1F2937)
                                : const Color(0xFF707781),
                          ),
                        ),
                        if (statuses[i].$2 && order.statusHistory.isNotEmpty)
                          Text(
                            _getStatusDate(statuses[i].$1),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF707781),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (i < statuses.length - 1)
                Padding(
                  padding: const EdgeInsets.only(left: 18, top: 8, bottom: 8),
                  child: Container(
                    height: 20,
                    width: 2,
                    color: statuses[i].$2
                        ? const Color(0xFF5886BF)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildDeliveryDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Delivery Details',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          _detailRow('Name', order.deliveryName),
          _detailRow('Phone', order.deliveryPhone),
          _detailRow('Email', order.deliveryEmail),
          _detailRow('Address', order.deliveryAddress),
          _detailRow(
            'Location',
            '${order.deliveryCity}, ${order.deliveryState} ${order.deliveryZip}',
          ),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF707781),
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Items',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // Product image
                    if (item.productImage != null)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                            image: NetworkImage(
                                '${ApiConfig.baseUrl}${item.productImage}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: const Color(0xFFF3F4F6),
                        ),
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    const SizedBox(width: 12),
                    // Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Qty: ${item.quantity}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF707781),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Price
                    Text(
                      'Rs. ${item.subtotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF5886BF),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Information',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 12),
          _summaryRow('Subtotal', 'Rs. ${order.totalAmount.toStringAsFixed(2)}'),
          if (order.discountApplied > 0) ...[
            const SizedBox(height: 8),
            _summaryRow(
              'Discount',
              '-Rs. ${order.discountApplied.toStringAsFixed(2)}',
              color: const Color(0xFFEF4444),
            ),
          ],
          const SizedBox(height: 8),
          _summaryRow(
            'Payment Method',
            order.paymentMethodDisplay,
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _summaryRow(
            'Total Amount',
            'Rs. ${order.finalAmount.toStringAsFixed(2)}',
            isBold: true,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _getPaymentStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Payment Status: ${order.paymentStatusDisplay}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _getPaymentStatusColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: const Color(0xFF707781),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            color: color ?? const Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  Color _getPaymentStatusColor() {
    switch (order.paymentStatus) {
      case 'paid':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFFCD34D);
      case 'failed':
        return const Color(0xFFEF4444);
      case 'refunded':
        return const Color(0xFF8B5CF6);
      default:
        return const Color(0xFF707781);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getStatusDate(String statusName) {
    try {
      final history = order.statusHistory
          .where((h) =>
              h.statusDisplay.toLowerCase() == statusName.toLowerCase())
          .firstOrNull;
      if (history != null) {
        return _formatDate(history.timestamp);
      }
    } catch (e) {
      print('Error getting status date: $e');
    }
    return '';
  }
}
