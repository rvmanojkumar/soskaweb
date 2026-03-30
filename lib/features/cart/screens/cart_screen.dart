import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/cart.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final cart = cartProvider.cart;
    
    if (cartProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('My Cart')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (cart == null || cart.items.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('My Cart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Add items to get started',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart (${cart.items.length} items)'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () => _showClearCartDialog(context, cartProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];
                return _buildCartItem(context, item, cartProvider);
              },
            ),
          ),
          _buildOrderSummary(context, cart),
        ],
      ),
    );
  }
  
  Widget _buildCartItem(BuildContext context, CartItem item, CartProvider cartProvider) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.productImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Icon(Icons.image_not_supported),
                ),
              ),
            ),
            SizedBox(width: 12),
            
            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${item.color}, ${item.size}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${item.currentPrice.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove, size: 18),
                              onPressed: () => _updateQuantity(
                                context,
                                item,
                                item.quantity - 1,
                                cartProvider,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                            Container(
                              width: 35,
                              child: Text(
                                '${item.quantity}',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.add, size: 18),
                              onPressed: () => _updateQuantity(
                                context,
                                item,
                                item.quantity + 1,
                                cartProvider,
                              ),
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20),
              onPressed: () => _removeItem(context, item, cartProvider),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildOrderSummary(BuildContext context, Cart cart) {
    final deliveryFee = cart.deliveryFee ?? 0;
    final total = cart.subtotal + deliveryFee - (cart.discount ?? 0);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPriceRow('Subtotal', '\$${cart.subtotal.toStringAsFixed(2)}'),
            _buildPriceRow('Delivery Fee', '\$${deliveryFee.toStringAsFixed(2)}'),
            if (cart.discount != null && cart.discount! > 0)
              _buildPriceRow(
                'Discount',
                '-\$${cart.discount!.toStringAsFixed(2)}',
                isDiscount: true,
              ),
            Divider(),
            _buildPriceRow(
              'Total',
              '\$${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/checkout');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: AppColors.primary,
                ),
                child: Text(
                  'PROCEED TO CHECKOUT',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPriceRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }
  
  Future<void> _updateQuantity(
    BuildContext context,
    CartItem item,
    int newQuantity,
    CartProvider cartProvider,
  ) async {
    if (newQuantity < 1) {
      _removeItem(context, item, cartProvider);
      return;
    }
    
    try {
      await cartProvider.updateQuantity(item.id, newQuantity);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update quantity')),
      );
    }
  }
  
  Future<void> _removeItem(
    BuildContext context,
    CartItem item,
    CartProvider cartProvider,
  ) async {
    try {
      await cartProvider.removeItem(item.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove item')),
      );
    }
  }
  
  void _showClearCartDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart'),
        content: Text('Are you sure you want to remove all items?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await cartProvider.clearCart();
              Navigator.pop(context);
            },
            child: Text('Clear'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }
}