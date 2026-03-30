import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../../../core/constants/app_colors.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  
  const OrderDetailScreen({Key? key, required this.orderId}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: FutureBuilder(
        future: orderProvider.loadOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          final order = orderProvider.currentOrder;
          if (order == null) {
            return Center(child: Text('Order not found'));
          }
          
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Status
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: order.statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(order.statusColor == Colors.green ? Icons.check_circle : Icons.pending,
                          color: order.statusColor),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.orderNumber}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              order.statusText,
                              style: TextStyle(color: order.statusColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Items
                Text('Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                ...order.items.map((item) => Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.productImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported),
                      ),
                    ),
                    title: Text(item.productName),
                    subtitle: Text('Qty: ${item.quantity} • Size: ${item.size}'),
                    trailing: Text('\$${item.total.toStringAsFixed(2)}'),
                  ),
                )),
                
                SizedBox(height: 24),
                
                // Order Summary
                Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildSummaryRow('Subtotal', '\$${order.subtotal.toStringAsFixed(2)}'),
                        _buildSummaryRow('Delivery Fee', '\$${order.deliveryFee.toStringAsFixed(2)}'),
                        if (order.discount > 0)
                          _buildSummaryRow('Discount', '-\$${order.discount.toStringAsFixed(2)}'),
                        Divider(),
                        _buildSummaryRow('Total', '\$${order.total.toStringAsFixed(2)}', isTotal: true),
                      ],
                    ),
                  ),
                ),
                
                SizedBox(height: 24),
                
                // Shipping Address
                Text('Shipping Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(order.shippingAddress.addressLine1),
                        if (order.shippingAddress.addressLine2 != null)
                          Text(order.shippingAddress.addressLine2!),
                        Text('${order.shippingAddress.city}, ${order.shippingAddress.state}'),
                        Text('${order.shippingAddress.postalCode}, ${order.shippingAddress.country}'),
                        Text('Phone: ${order.shippingAddress.phone}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}