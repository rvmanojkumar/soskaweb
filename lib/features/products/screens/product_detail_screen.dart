import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/product_provider.dart';
import '../../cart/providers/cart_provider.dart';
import '../../wishlist/providers/wishlist_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/models/product.dart';
import '../../../core/models/review.dart';
import '../../../core/models/question.dart';
import '../../../core/constants/app_colors.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedImageIndex = 0;
  String? _selectedColor;
  String? _selectedSize;
  String? _selectedVariantId;
  int _quantity = 1;
  bool _isInWishlist = false;
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);

    await productProvider.loadProductDetails(widget.productId);
    await productProvider.loadProductReviews(widget.productId);
    await productProvider.loadProductQuestions(widget.productId);

    // Check if product is in wishlist
    _isInWishlist = wishlistProvider.isInWishlist(widget.productId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final product = productProvider.currentProduct;

    if (productProvider.isLoadingProduct) {
      return Scaffold(
        appBar: AppBar(title: Text('Product Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Product Details')),
        body: Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: Icon(
              _isInWishlist ? Icons.favorite : Icons.favorite_border,
              color: _isInWishlist ? Colors.red : null,
            ),
            onPressed: () => _toggleWishlist(product),
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareProduct(product),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            _buildImageCarousel(product),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand & Title
                  _buildBrandAndTitle(product),

                  SizedBox(height: 12),

                  // Rating
                  _buildRating(product),

                  SizedBox(height: 16),

                  // Price
                  _buildPrice(product),

                  SizedBox(height: 24),

                  // Color Selection
                  if (product.colors != null && product.colors!.isNotEmpty)
                    _buildColorSelection(product),

                  // Size Selection
                  if (product.sizes != null && product.sizes!.isNotEmpty)
                    _buildSizeSelection(product),

                  SizedBox(height: 16),

                  // Quantity
                  _buildQuantitySelector(product),

                  SizedBox(height: 24),

                  // Action Buttons
                  _buildActionButtons(product),

                  SizedBox(height: 24),

                  // Description
                  _buildDescription(product),

                  SizedBox(height: 24),

                  // Reviews Section
                  _buildReviewsSection(productProvider),

                  SizedBox(height: 24),

                  // Q&A Section
                  _buildQuestionsSection(productProvider),

                  SizedBox(height: 24),

                  // Social Share
                  _buildSocialShare(product),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel(Product product) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          PageView.builder(
            onPageChanged: (index) {
              setState(() {
                _selectedImageIndex = index;
              });
            },
            itemCount: product.images.length,
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: product.images[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.image_not_supported,
                  size: 100,
                ),
              );
            },
          ),
          // Image indicators
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                product.images.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _selectedImageIndex == index
                        ? AppColors.primary
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          // Discount badge
          if (product.discountPrice != null)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.discountPercentage.toStringAsFixed(0)}% OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBrandAndTitle(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.brand,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        Text(
          product.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ],
    );
  }

  Widget _buildRating(Product product) {
    return Row(
      children: [
        RatingBar.builder(
          initialRating: product.rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: 20,
          ignoreGestures: true,
          itemBuilder: (context, _) => Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {},
        ),
        SizedBox(width: 8),
        Text(
          '(${product.reviewCount} reviews)',
          style: TextStyle(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(Product product) {
    return Row(
      children: [
        Text(
          '\$${product.currentPrice.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        if (product.discountPrice != null) ...[
          SizedBox(width: 8),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              decoration: TextDecoration.lineThrough,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(width: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildColorSelection(Product product) {
    final colors = product.colors;
    if (colors == null || colors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: colors.map((color) {
            final isSelected = _selectedColor == color;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(color),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSizeSelection(Product product) {
    final sizes = product.sizes;
    if (sizes == null || sizes.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: sizes.map((size) {
            final isSelected = _selectedSize == size;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedSize = size;
                });
              },
              child: Container(
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    size,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildQuantitySelector(Product product) {
    return Row(
      children: [
        Text(
          'Quantity',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove, size: 20),
                onPressed: () {
                  if (_quantity > 1) {
                    setState(() {
                      _quantity--;
                    });
                  }
                },
              ),
              Container(
                width: 40,
                child: Text(
                  '$_quantity',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, size: 20),
                onPressed: () {
                  if (_quantity < product.stockQuantity) {
                    setState(() {
                      _quantity++;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Spacer(),
        if (!product.inStock)
          Text(
            'Out of Stock',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(Product product) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: product.inStock ? () => _addToCart(product) : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'ADD TO CART',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            onPressed: product.inStock ? () => _buyNow(product) : null,
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'BUY NOW',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 14,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(ProductProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Customer Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showAddReviewDialog(),
              child: Text('Write a Review'),
            ),
          ],
        ),
        SizedBox(height: 12),
        if (productProvider.isLoadingReviews)
          Center(child: CircularProgressIndicator())
        else if (productProvider.reviews.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No reviews yet. Be the first to review!',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: productProvider.reviews.length > 3
                ? 3
                : productProvider.reviews.length,
            itemBuilder: (context, index) {
              final review = productProvider.reviews[index];
              return _buildReviewCard(review);
            },
          ),
        if (productProvider.reviews.length > 3)
          Center(
            child: TextButton(
              onPressed: () {
                // Navigate to all reviews
              },
              child: Text('View all ${productProvider.reviews.length} reviews'),
            ),
          ),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    review.userName[0].toUpperCase(),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      RatingBar.builder(
                        initialRating: review.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 12,
                        ignoreGestures: true,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 12,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDate(review.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(review.comment),
            if (review.images.isNotEmpty)
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: CachedNetworkImage(
                          imageUrl: review.images[i],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsSection(ProductProvider productProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Questions & Answers',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => _showAskQuestionDialog(),
              child: Text('Ask a Question'),
            ),
          ],
        ),
        SizedBox(height: 12),
        if (productProvider.isLoadingQuestions)
          Center(child: CircularProgressIndicator())
        else if (productProvider.questions.isEmpty)
          Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Text(
                'No questions yet. Ask the first question!',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: productProvider.questions.length > 3
                ? 3
                : productProvider.questions.length,
            itemBuilder: (context, index) {
              final question = productProvider.questions[index];
              return _buildQuestionCard(question);
            },
          ),
      ],
    );
  }

  Widget _buildQuestionCard(Question question) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    question.userName[0].toUpperCase(),
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question.userName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        _formatDate(question.createdAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              question.question,
              style: TextStyle(fontSize: 14),
            ),
            if (question.isAnswered) ...[
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.reply, size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seller Response:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          question.answer!,
                          style: TextStyle(fontSize: 13),
                        ),
                        if (question.answeredAt != null)
                          Text(
                            _formatDate(question.answeredAt!),
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSocialShare(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Share this product',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildSocialButton(
              icon: Icons.facebook,
              color: Color(0xFF1877F2),
              onTap: () => _shareOnFacebook(product),
            ),
            SizedBox(width: 12),
            _buildSocialButton(
              icon: Icons.chat,
              color: Color(0xFF25D366),
              onTap: () => _shareOnWhatsApp(product),
            ),
            SizedBox(width: 12),
            _buildSocialButton(
              icon: Icons.camera_alt,
              color: Color(0xFFE4405F),
              onTap: () => _shareOnInstagram(product),
            ),
            SizedBox(width: 12),
            _buildSocialButton(
              icon: Icons.message,
              color: Color(0xFF1DA1F2),
              onTap: () => _shareOnTwitter(product),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: color,
          size: 24,
        ),
      ),
    );
  }

  void _addToCart(Product product) async {
    if (product.colors.isNotEmpty && _selectedColor == null) {
      _showError('Please select a color');
      return;
    }

    if (product.sizes.isNotEmpty && _selectedSize == null) {
      _showError('Please select a size');
      return;
    }

    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      _showError('Please login to add items to cart');
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      // Use variant ID if available, otherwise use product ID
      final variantId = _selectedVariantId ?? product.id;
      await cartProvider.addToCart(variantId, _quantity);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added to cart'),
          action: SnackBarAction(
            label: 'VIEW CART',
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ),
      );
    } catch (e) {
      _showError('Failed to add to cart: $e');
    }
  }

  void _buyNow(Product product) {
    _addToCart(product);
    Navigator.pushNamed(context, '/cart');
  }

  void _toggleWishlist(Product product) async {
    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      _showError('Please login to add to wishlist');
      Navigator.pushNamed(context, '/login');
      return;
    }

    try {
      if (_isInWishlist) {
        await wishlistProvider.removeFromWishlist(product.id);
        setState(() => _isInWishlist = false);
        _showSuccess('Removed from wishlist');
      } else {
        await wishlistProvider.addToWishlist(product.id);
        setState(() => _isInWishlist = true);
        _showSuccess('Added to wishlist');
      }
    } catch (e) {
      _showError('Failed to update wishlist');
    }
  }

  void _showAddReviewDialog() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      _showError('Please login to write a review');
      Navigator.pushNamed(context, '/login');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text('Write a Review'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 32,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setStateDialog(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _reviewController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Write your review here...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => _submitReview(),
                child: Text('Submit'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitReview() async {
    if (_rating == 0) {
      _showError('Please select a rating');
      return;
    }

    if (_reviewController.text.isEmpty) {
      _showError('Please write your review');
      return;
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      await productProvider.submitReview(
        widget.productId,
        {
          'rating': _rating,
          'review': _reviewController.text,
        },
      );

      Navigator.pop(context);
      _reviewController.clear();
      _rating = 0;
      _showSuccess('Review submitted successfully');
    } catch (e) {
      _showError('Failed to submit review');
    }
  }

  void _showAskQuestionDialog() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      _showError('Please login to ask a question');
      Navigator.pushNamed(context, '/login');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ask a Question'),
        content: TextField(
          controller: _questionController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Type your question here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => _submitQuestion(),
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitQuestion() async {
    if (_questionController.text.isEmpty) {
      _showError('Please enter your question');
      return;
    }

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    try {
      await productProvider.askQuestion(
        widget.productId,
        _questionController.text,
      );

      Navigator.pop(context);
      _questionController.clear();
      _showSuccess('Question submitted successfully');
    } catch (e) {
      _showError('Failed to submit question');
    }
  }

  void _shareProduct(Product product) async {
    final shareText =
        'Check out ${product.name} at Soskali Lifestyles!\n\nPrice: \$${product.currentPrice}\n\nRating: ${product.rating}⭐ (${product.reviewCount} reviews)';
    await Share.share(shareText);
  }

  void _shareOnFacebook(Product product) async {
    final url =
        'https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent('https://soskalifestyles.com/product/${product.id}')}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _shareOnWhatsApp(Product product) async {
    final text = 'Check out ${product.name} at Soskali Lifestyles!';
    final url = 'https://wa.me/?text=${Uri.encodeComponent(text)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _shareOnInstagram(Product product) async {
    _showInfo('Instagram sharing coming soon!');
  }

  void _shareOnTwitter(Product product) async {
    final text = 'Check out ${product.name} at Soskali Lifestyles!';
    final url =
        'https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
