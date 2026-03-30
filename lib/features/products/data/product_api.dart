import '../../../core/network/api_client.dart';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/models/product.dart';
import '../../../core/models/category.dart';
import '../../../core/models/banner.dart';
import '../../../core/models/review.dart';
import '../../../core/models/question.dart';

class ProductApi {
  final ApiClient _apiClient = ApiClient();

  Future<List<Product>> getProducts({
    int page = 1,
    int perPage = 20,
    String? categoryId,
    String? sortBy = 'created_at',
    String? sortOrder = 'desc',
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.products,
        queryParams: {
          'page': page,
          'per_page': perPage,
          if (categoryId != null) 'category_id': categoryId,
          'sort_by': sortBy,
          'sort_order': sortOrder,
        },
      );

      final List<dynamic> productsData = response['data'] ?? response;
      return productsData.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print('Error getting products: $e');
      return [];
    }
  }

  Future<Product> getProductById(String id) async {
    try {
      final endpoint = '${ApiEndpoints.products}/$id';
      final response = await _apiClient.get(endpoint);
      final productData = response['data'] ?? response;
      return Product.fromJson(productData);
    } catch (e) {
      print('Error getting product: $e');
      rethrow;
    }
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.categories);
      final List<dynamic> categoriesData = response['data'] ?? response;
      return categoriesData.map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  Future<List<BannerModel>> getBanners() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.banners);
      final List<dynamic> bannersData = response['data'] ?? response;
      return bannersData.map((json) => BannerModel.fromJson(json)).toList();
    } catch (e) {
      print('Error getting banners: $e');
      return [];
    }
  }

  Future<List<Review>> getProductReviews(String productId) async {
    try {
      final endpoint =
          ApiEndpoints.productReviews.replaceAll('{id}', productId);
      final response = await _apiClient.get(endpoint);
      final List<dynamic> reviewsData = response['data'] ?? response;
      return reviewsData.map((json) => Review.fromJson(json)).toList();
    } catch (e) {
      print('Error getting reviews: $e');
      return [];
    }
  }

  Future<Review> submitReview(
      String productId, Map<String, dynamic> data) async {
    try {
      final endpoint = ApiEndpoints.submitReview.replaceAll('{id}', productId);
      final response = await _apiClient.post(endpoint, data: data);
      final reviewData = response['data'] ?? response;
      return Review.fromJson(reviewData);
    } catch (e) {
      print('Error submitting review: $e');
      rethrow;
    }
  }

  Future<List<Question>> getProductQuestions(String productId) async {
    try {
      final endpoint =
          ApiEndpoints.productQuestions.replaceAll('{id}', productId);
      final response = await _apiClient.get(endpoint);
      final List<dynamic> questionsData = response['data'] ?? response;
      return questionsData.map((json) => Question.fromJson(json)).toList();
    } catch (e) {
      print('Error getting questions: $e');
      return [];
    }
  }

  Future<Question> askQuestion(String productId, String question) async {
    try {
      final endpoint = ApiEndpoints.askQuestion.replaceAll('{id}', productId);
      final response = await _apiClient.post(
        endpoint,
        data: {'question': question},
      );
      final questionData = response['data'] ?? response;
      return Question.fromJson(questionData);
    } catch (e) {
      print('Error asking question: $e');
      rethrow;
    }
  }
}
