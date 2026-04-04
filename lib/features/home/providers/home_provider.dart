import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/models/product.dart';
import '../../../core/models/category.dart';
import '../../../core/models/banner.dart'; // Now imports BannerModel

class HomeProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  List<BannerModel> _banners = []; // Changed from Banner to BannerModel
  List<Category> _categories = [];
  List<Product> _products = [];

  bool _isLoading = false;
  String? _error;

  List<BannerModel> get banners => _banners; // Changed return type
  List<Category> get categories => _categories;
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await Future.wait([
        fetchBanners(),
        fetchCategories(),
        fetchProducts(),
      ]);
    } catch (e) {
      _error = e.toString();
      print('Error fetching home data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchBanners() async {
    try {
      final response = await _api.get('/banners');
      print('Banners response: $response');

      // Handle different response structures
      List<dynamic> bannersData;
      if (response['data'] != null) {
        bannersData = response['data'];
      } else if (response is List) {
        bannersData = response;
      } else {
        bannersData = [];
      }

      _banners = bannersData
          .map((json) => BannerModel.fromJson(json))
          .toList(); // Changed to BannerModel
    } catch (e) {
      print('Error fetching banners: $e');
      _banners = [];
    }
  }

  Future<void> fetchCategories() async {
    try {
      final response = await _api.get('/categories');
      print('Categories response: $response');

      // Handle different response structures
      List<dynamic> categoriesData;
      if (response['data'] != null) {
        categoriesData = response['data'];
      } else if (response is List) {
        categoriesData = response;
      } else {
        categoriesData = [];
      }

      _categories =
          categoriesData.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching categories: $e');
      _categories = [];
    }
  }

  Future<void> fetchProducts() async {
    try {
      final response = await _api.get('/products', queryParams: {
        'page': 1,
        'per_page': 20,
        'sort_by': 'created_at',
        'sort_order': 'desc',
      });
      print('Products response: $response');

      // Handle different response structures
      List<dynamic> productsData;
      if (response['data'] != null) {
        productsData = response['data'];
      } else if (response is List) {
        productsData = response;
      } else {
        productsData = [];
      }

      _products = productsData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching products: $e');
      _products = [];
    }
  }
}
