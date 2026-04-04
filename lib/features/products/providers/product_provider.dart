import 'package:flutter/material.dart';
import '../../shared/data/banner_api.dart';
import '../data/product_api.dart';
import '../../../core/models/product.dart';
import '../../../core/models/category.dart';
import '../../../core/models/banner.dart';
import '../../../core/models/review.dart';
import '../../../core/models/question.dart';

class ProductProvider extends ChangeNotifier {
  final ProductApi _productApi = ProductApi();

  List<Product> _featuredProducts = [];
  List<Product> _trendingProducts = [];
  List<Product> _newArrivals = [];
  List<Product> _allProducts = []; // Add this for product listing
  List<Category> _categories = [];
  List<BannerModel> _banners = [];
  Product? _currentProduct;
  List<Review> _reviews = [];
  List<Question> _questions = [];

  bool _isLoading = false;
  bool _isLoadingProduct = false;
  bool _isLoadingReviews = false;
  bool _isLoadingQuestions = false;
  bool _isLoadingMore = false; // For pagination
  int _currentPage = 1;
  bool _hasMore = true;

  // Getters
  List<Product> get featuredProducts => _featuredProducts;
  List<Product> get trendingProducts => _trendingProducts;
  List<Product> get newArrivals => _newArrivals;
  List<Product> get allProducts => _allProducts;
  List<Category> get categories => _categories;
  List<BannerModel> get banners => _banners;
  Product? get currentProduct => _currentProduct;
  List<Review> get reviews => _reviews;
  List<Question> get questions => _questions;
  bool get isLoading => _isLoading;
  bool get isLoadingProduct => _isLoadingProduct;
  bool get isLoadingReviews => _isLoadingReviews;
  bool get isLoadingQuestions => _isLoadingQuestions;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;

  // Load Methods
  Future<void> loadFeaturedProducts() async {
    try {
      _featuredProducts = await _productApi.getProducts(
        sortBy: 'featured',
        perPage: 10,
      );
      notifyListeners();
    } catch (e) {
      print('Error loading featured products: $e');
    }
  }

  Future<void> loadTrendingProducts() async {
    try {
      _trendingProducts = await _productApi.getProducts(
        sortBy: 'popular',
        perPage: 10,
      );
      notifyListeners();
    } catch (e) {
      print('Error loading trending products: $e');
    }
  }

  Future<void> loadNewArrivals() async {
    try {
      _newArrivals = await _productApi.getProducts(
        sortBy: 'newest',
        perPage: 10,
      );
      notifyListeners();
    } catch (e) {
      print('Error loading new arrivals: $e');
    }
  }

  // Add this method for product listing with pagination
  Future<List<Product>> getProducts({
    int page = 1,
    int perPage = 20,
    String? categoryId,
    String? sortBy = 'created_at',
    String? sortOrder = 'desc',
  }) async {
    try {
      final products = await _productApi.getProducts(
        page: page,
        perPage: perPage,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
      return products;
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  // Add method for loading more products (pagination)
  Future<void> loadMoreProducts({
    String? categoryId,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      _currentPage++;
      final newProducts = await _productApi.getProducts(
        page: _currentPage,
        perPage: 20,
        categoryId: categoryId,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (newProducts.isEmpty || newProducts.length < 20) {
        _hasMore = false;
      }

      _allProducts.addAll(newProducts);
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
      print('Error loading more products: $e');
    }
  }

  // Reset products for new category/filter
  void resetProducts() {
    _allProducts = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    try {
      _categories = await _productApi.getCategories();
      notifyListeners();
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> loadBanners() async {
    try {
      _banners = await _productApi.getBanners();
      
      notifyListeners();
    } catch (e) {
      print('Error loading banners: $e');
    }
  }

  Future<void> loadProductDetails(String productId) async {
    _isLoadingProduct = true;
    notifyListeners();

    try {
      _currentProduct = await _productApi.getProductById(productId);
      _isLoadingProduct = false;
      notifyListeners();
    } catch (e) {
      _isLoadingProduct = false;
      notifyListeners();
      print('Error loading product details: $e');
    }
  }

  Future<void> loadProductReviews(String productId) async {
    _isLoadingReviews = true;
    notifyListeners();

    try {
      _reviews = await _productApi.getProductReviews(productId);
      _isLoadingReviews = false;
      notifyListeners();
    } catch (e) {
      _isLoadingReviews = false;
      notifyListeners();
      print('Error loading reviews: $e');
    }
  }

  Future<void> loadProductQuestions(String productId) async {
    _isLoadingQuestions = true;
    notifyListeners();

    try {
      _questions = await _productApi.getProductQuestions(productId);
      _isLoadingQuestions = false;
      notifyListeners();
    } catch (e) {
      _isLoadingQuestions = false;
      notifyListeners();
      print('Error loading questions: $e');
    }
  }

  Future<void> submitReview(String productId, Map<String, dynamic> data) async {
    try {
      final newReview = await _productApi.submitReview(productId, data);
      _reviews.insert(0, newReview);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> askQuestion(String productId, String question) async {
    try {
      final newQuestion = await _productApi.askQuestion(productId, question);
      _questions.insert(0, newQuestion);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
