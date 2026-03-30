import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/category_card.dart';
import '../../shared/widgets/banner_carousel.dart';
import '../../shared/widgets/custom_nav_bar.dart';
import '../../shared/widgets/footer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/product.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    await Future.wait([
      productProvider.loadCategories(),
      productProvider.loadBanners(),
      productProvider.loadFeaturedProducts(),
      productProvider.loadNewArrivals(),
      productProvider.loadTrendingProducts(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                ),
              ),
              title: Text('Soskali Lifestyles'),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: CustomNavBar(),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banners
                if (productProvider.banners.isNotEmpty)
                  BannerCarousel(banners: productProvider.banners),

                SizedBox(height: 24),

                // Categories
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shop by Category',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/categories');
                        },
                        child: Text('View All'),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = productProvider.categories[index];
                      return CategoryCard(
                        name: category.name,
                        icon: _getCategoryIcon(category.name),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/products',
                            arguments: {
                              'categoryId': category.id,
                              'categoryName': category.name,
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                SizedBox(height: 32),

                // Trending Products
                if (productProvider.trendingProducts.isNotEmpty)
                  _buildProductSection(
                    title: 'Trending Now',
                    products: productProvider.trendingProducts,
                  ),

                SizedBox(height: 32),

                // Offer Banner (Static until flash sale API is available)
                _buildOfferBanner(),

                SizedBox(height: 32),

                // New Arrivals
                if (productProvider.newArrivals.isNotEmpty)
                  _buildProductSection(
                    title: 'New Arrivals',
                    products: productProvider.newArrivals,
                  ),

                SizedBox(height: 32),

                // Brands Section (Static until brands API is available)
                _buildBrandsSection(),

                SizedBox(height: 48),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Footer(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSection(
      {required String title, required List<Product> products}) {
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

  Widget _buildOfferBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      height: 150,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.network(
              'https://via.placeholder.com/200',
              height: 140,
              errorBuilder: (context, error, stackTrace) => SizedBox.shrink(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FLASH SALE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Up to 50% Off',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/products');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepOrange,
                  ),
                  child: Text('Shop Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandsSection() {
    // Static brands until API is available
    final brands = ['Nike', 'Adidas', 'Puma', 'Zara', 'H&M', 'Levi\'s'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Top Brands',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: brands.length,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    brands[index],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'clothing':
        return Icons.checkroom;
      case 'accessories':
        return Icons.watch;
      case 'home':
        return Icons.home;
      default:
        return Icons.category;
    }
  }
}
