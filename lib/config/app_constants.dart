class AppConstants {
  static const String appName = 'Soskali Lifestyles';
  static const String baseUrl = 'https://api.soskalifestyles.com'; // Replace with actual API URL
  
  // API Endpoints
  static const String loginEndpoint = '/api/auth/login';
  static const String signupEndpoint = '/api/auth/register';
  static const String forgotPasswordEndpoint = '/api/auth/forgot-password';
  static const String productsEndpoint = '/api/products';
  static const String categoriesEndpoint = '/api/categories';
  static const String brandsEndpoint = '/api/brands';
  static const String cartEndpoint = '/api/cart';
  static const String ordersEndpoint = '/api/orders';
  static const String wishlistEndpoint = '/api/wishlist';
  static const String userProfileEndpoint = '/api/user/profile';
  static const String walletEndpoint = '/api/user/wallet';
  static const String couponsEndpoint = '/api/coupons';
  
  // Shared Preferences Keys
  static const String authToken = 'auth_token';
  static const String userData = 'user_data';
  static const String themeMode = 'theme_mode';
  static const String cartItems = 'cart_items';
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Razorpay Keys
  static const String razorpayKey = 'rzp_test_xxxxxxxxxxxx'; // Replace with actual key
}