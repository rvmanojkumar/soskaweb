import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';

class CustomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
            child: Text(
              'SOSKALI',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          SizedBox(width: 24),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButton<String>(
              hint: Text('Categories'),
              underline: SizedBox(),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Categories')),
              ],
              onChanged: (value) {
                if (value != null) {
                  Navigator.pushNamed(context, '/products');
                }
              },
            ),
          ),

          SizedBox(width: 16),

          Expanded(
            child: GestureDetector(
              onTap: () {
                // Navigate to search screen
              },
              child: Container(
                height: 45,
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Search for products...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 16),

          GestureDetector(
            onTap: () {
              if (authProvider.isAuthenticated) {
                Navigator.pushNamed(context, '/profile');
              } else {
                Navigator.pushNamed(context, '/login');
              }
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.person_outline),
            ),
          ),

          // Wallet Display - Now using the walletBalance getter
          if (authProvider.isAuthenticated)
            Container(
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet,
                      size: 18, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    '\$${authProvider.user?.walletBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.itemCount}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
