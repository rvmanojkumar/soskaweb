import 'package:flutter/material.dart';
import '../../../core/models/product.dart';
import '../../products/widgets/product_card.dart';

class HomeProductSection extends StatelessWidget {
  final String title;
  final List<Product> products;
  
  const HomeProductSection({
    Key? key,
    required this.title,
    required this.products,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/products');
                },
                child: Text('View All'),
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: EdgeInsets.only(right: 16),
                child: ProductCard(
                  product: products[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/product',
                      arguments: {'productId': products[index].id},
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}