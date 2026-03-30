import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/address.dart';
import '../../../core/models/cart.dart'; // Add this import for Cart class

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  Address? _selectedAddress;
  String _paymentMethod = 'razorpay';
  String? _promoCode;
  double _discount = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final cart = cartProvider.cart;

    if (cart == null || cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Checkout')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('Your cart is empty'),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      );
    }

    final subtotal = cart.subtotal;
    final deliveryFee = cart.deliveryFee ?? 0;
    final total = subtotal + deliveryFee - _discount;

    return Scaffold(
      appBar: AppBar(title: Text('Checkout')),
      body: _isProcessing
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address Section
                  _buildAddressSection(profileProvider),
                  SizedBox(height: 24),

                  // Order Summary
                  _buildOrderSummary(cart, subtotal, deliveryFee, total),
                  SizedBox(height: 24),

                  // Payment Method
                  _buildPaymentMethod(),
                  SizedBox(height: 24),

                  // Total
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Place Order Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedAddress == null
                          ? null
                          : () => _placeOrder(total),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                      ),
                      child: Text(
                        'PLACE ORDER',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAddressSection(ProfileProvider profileProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () async {
                await Navigator.pushNamed(context, '/addresses');
                await profileProvider.loadAddresses();
                setState(() {});
              },
              child: Text('Manage'),
            ),
          ],
        ),
        SizedBox(height: 12),
        if (profileProvider.addresses.isEmpty)
          Center(
            child: Column(
              children: [
                Text('No addresses saved'),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/addresses'),
                  child: Text('Add New Address'),
                ),
              ],
            ),
          )
        else
          ...profileProvider.addresses.map((address) {
            final isSelected = _selectedAddress?.id == address.id;
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              child: RadioListTile<Address>(
                value: address,
                groupValue: _selectedAddress,
                onChanged: (value) => setState(() => _selectedAddress = value),
                title: Text(address.addressLine1),
                subtitle: Text(
                  '${address.city}, ${address.state} - ${address.postalCode}\nPhone: ${address.phone}',
                ),
                controlAffinity: ListTileControlAffinity.trailing,
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildOrderSummary(
      Cart cart, double subtotal, double deliveryFee, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Card(
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                for (var item in cart.items)
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Text('${item.quantity}x',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Expanded(child: Text(item.productName)),
                        Text('\$${item.totalPrice.toStringAsFixed(2)}'),
                      ],
                    ),
                  ),
                Divider(),
                _buildOrderRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
                _buildOrderRow(
                    'Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
                if (_discount > 0)
                  _buildOrderRow(
                      'Discount', '-\$${_discount.toStringAsFixed(2)}',
                      isDiscount: true),
                Divider(),
                _buildOrderRow('Total', '\$${total.toStringAsFixed(2)}',
                    isTotal: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderRow(String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Method',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              RadioListTile<String>(
                value: 'razorpay',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
                title: Text('Credit/Debit Card, UPI, NetBanking'),
                subtitle: Text('Powered by Razorpay'),
              ),
              RadioListTile<String>(
                value: 'wallet',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
                title: Text('Soskali Wallet'),
              ),
              RadioListTile<String>(
                value: 'cod',
                groupValue: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value!),
                title: Text('Cash on Delivery'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _placeOrder(double total) async {
    setState(() => _isProcessing = true);

    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

    try {
      await orderProvider.checkout(
        addressId: _selectedAddress!.id,
        paymentMethod: _paymentMethod,
        promoCode: _promoCode,
      );

      // Show success and navigate
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green),
      );

      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      setState(() => _isProcessing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to place order: $e'),
            backgroundColor: Colors.red),
      );
    }
  }
}
