import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../../products/widgets/product_card.dart';
import '../../../core/constants/app_colors.dart';

class WishlistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Wishlist (${wishlistProvider.itemCount})'),
      ),
      body: wishlistProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : wishlistProvider.wishlistItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Your wishlist is empty',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Save items you love to your wishlist',
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
                )
              : GridView.builder(
                  padding: EdgeInsets.all(12),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: wishlistProvider.wishlistItems.length,
                  itemBuilder: (context, index) {
                    final product = wishlistProvider.wishlistItems[index];
                    return ProductCard(
                      product: product,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/product',
                          arguments: {'productId': product.id},
                        );
                      },
                    );
                  },
                ),
    );
  }
}