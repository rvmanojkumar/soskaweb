import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/product.dart';

class ProductListScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;

  const ProductListScreen({
    Key? key,
    this.categoryId,
    this.categoryName,
  }) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Product> _products = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _currentSortBy = 'created_at';
  String? _currentSortOrder = 'desc';

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts({bool reset = true}) async {
    if (reset) {
      setState(() {
        _isLoading = true;
        _products = [];
        _currentPage = 1;
        _hasMore = true;
      });
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      final newProducts = await productProvider.getProducts(
        page: _currentPage,
        categoryId: widget.categoryId,
        sortBy: _currentSortBy,
        sortOrder: _currentSortOrder,
      );

      setState(() {
        if (reset) {
          _products = newProducts;
        } else {
          _products.addAll(newProducts);
        }
        _hasMore = newProducts.length >= 20;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
      print('Error loading products: $e');
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    await _loadProducts(reset: false);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _refreshProducts() async {
    setState(() {
      _currentPage = 1;
      _hasMore = true;
    });
    await _loadProducts(reset: true);
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort By',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildSortOption('Newest', 'created_at', 'desc'),
            _buildSortOption('Price: Low to High', 'price', 'asc'),
            _buildSortOption('Price: High to Low', 'price', 'desc'),
            _buildSortOption('Popularity', 'popular', 'desc'),
            _buildSortOption('Rating', 'rating', 'desc'),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String sortBy, String sortOrder) {
    final isSelected =
        _currentSortBy == sortBy && _currentSortOrder == sortOrder;

    return ListTile(
      title: Text(label),
      trailing: isSelected ? Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        setState(() {
          _currentSortBy = sortBy;
          _currentSortOrder = sortOrder;
          _currentPage = 1;
        });
        Navigator.pop(context);
        _refreshProducts();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName ?? 'Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _showSortDialog,
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Show filter dialog
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: _buildFilterBar(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: _isLoading && _products.isEmpty
            ? Center(child: CircularProgressIndicator())
            : _products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No products found',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Try adjusting your filters',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(12),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _products.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _products.length) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return ProductCard(
                        product: _products[index],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/product',
                            arguments: {'productId': _products[index].id},
                          );
                        },
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('All', null),
          SizedBox(width: 8),
          _buildFilterChip('Under \$25', 'price_0_25'),
          SizedBox(width: 8),
          _buildFilterChip('\$25 - \$50', 'price_25_50'),
          SizedBox(width: 8),
          _buildFilterChip('\$50 - \$100', 'price_50_100'),
          SizedBox(width: 8),
          _buildFilterChip('Over \$100', 'price_100_plus'),
          SizedBox(width: 8),
          _buildFilterChip('4★ & above', 'rating_4'),
          SizedBox(width: 8),
          _buildFilterChip('In Stock', 'in_stock'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String? filterValue) {
    return FilterChip(
      label: Text(label),
      onSelected: (selected) {
        // Handle filter selection
        if (selected) {
          // Apply filter
        } else {
          // Remove filter
        }
        _refreshProducts();
      },
      selected: false,
      backgroundColor: Colors.grey[100],
      selectedColor: AppColors.primary.withOpacity(0.1),
      labelStyle: TextStyle(
        color: Colors.black87,
      ),
      checkmarkColor: AppColors.primary,
    );
  }
}
