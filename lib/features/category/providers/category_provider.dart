import 'package:flutter/material.dart';
import '../data/category_api.dart';
import '../../../core/models/category.dart';
import '../../../core/models/product.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryApi _categoryApi = CategoryApi();

  List<Category> _categories = [];
  Category? _selectedCategory;
  List<Product> _categoryProducts = [];

  bool _isLoading = false;
  bool _isLoadingProducts = false;
  String? _error;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // Getters
  List<Category> get categories => _categories;
  Category? get selectedCategory => _selectedCategory;
  List<Product> get categoryProducts => _categoryProducts;
  bool get isLoading => _isLoading;
  bool get isLoadingProducts => _isLoadingProducts;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  // Get parent categories (categories with no parent)
  List<Category> get parentCategories {
    return _categories.where((category) => category.parentId == null).toList();
  }

  // Get subcategories for a parent category
  List<Category> getSubcategories(String parentId) {
    return _categories
        .where((category) => category.parentId == parentId)
        .toList();
  }

  // Load all categories
  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _categories = await _categoryApi.getCategories();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error loading categories: $e');
    }
  }

  // Load category details
  Future<void> loadCategoryDetails(String categoryId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _selectedCategory = await _categoryApi.getCategoryDetails(categoryId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error loading category details: $e');
    }
  }

  // Load products for a category
  Future<void> loadCategoryProducts(
    String categoryId, {
    bool reset = true,
    String? sortBy,
    String? sortOrder,
  }) async {
    if (reset) {
      _isLoadingProducts = true;
      _currentPage = 1;
      _hasMore = true;
      _categoryProducts = [];
    } else {
      _isLoadingMore = true;
    }
    _error = null;
    notifyListeners();

    try {
      final products = await _categoryApi.getCategoryProducts(
        categoryId,
        page: _currentPage,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );

      if (reset) {
        _categoryProducts = products;
      } else {
        _categoryProducts.addAll(products);
      }

      _hasMore = products.length >= 20;
      _isLoadingProducts = false;
      _isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingProducts = false;
      _isLoadingMore = false;
      notifyListeners();
      print('Error loading category products: $e');
    }
  }

  // Load more products (pagination)
  Future<void> loadMoreProducts(String categoryId) async {
    if (_isLoadingMore || !_hasMore) return;

    _currentPage++;
    await loadCategoryProducts(categoryId, reset: false);
  }

  // Reset category products
  void resetProducts() {
    _categoryProducts = [];
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
