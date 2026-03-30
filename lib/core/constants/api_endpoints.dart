class ApiEndpoints {
  static const String baseUrl =
      'https://api.soskalifestyles.com/api/v1'; // Replace with your actual URL

  // Authentication
  static const String login = '/auth/login';
  static const String userProfile = '/user';
  static const String updateProfile = '/user/profile';
  static const String logout = '/user/logout';

  // Products
  static const String products = '/products';
  static const String productVariants = '/products/{id}/variants';
  static const String productReviews = '/products/{id}/reviews';
  static const String submitReview = '/products/{id}/reviews';
  static const String updateReview = '/reviews/{id}';
  static const String deleteReview = '/reviews/{id}';
  static const String markReviewHelpful = '/reviews/{id}/helpful';
  static const String productQuestions = '/products/{id}/questions';
  static const String askQuestion = '/products/{id}/questions';

  // Categories
  static const String categories = '/categories';
  static const String categoryProducts = '/categories/{id}/products';

  // Cart
  static const String cart = '/cart';
  static const String addToCart = '/cart/add';
  static const String updateCartItem = '/cart/update/{id}';
  static const String removeCartItem = '/cart/remove/{id}';
  static const String clearCart = '/cart/clear';

  // Orders
  static const String checkout = '/checkout';
  static const String verifyPayment = '/verify-payment';
  static const String orders = '/orders';
  static const String orderDetails = '/orders/{id}';
  static const String cancelOrder = '/orders/{id}/cancel';

  // Wishlist
  static const String wishlist = '/wishlist';
  static const String addToWishlist = '/wishlist/add/{id}';
  static const String removeFromWishlist = '/wishlist/remove/{id}';

  // Addresses
  static const String addresses = '/addresses';
  static const String addAddress = '/addresses';
  static const String updateAddress = '/addresses/{id}';
  static const String deleteAddress = '/addresses/{id}';

  // Wallet
  static const String wallet = '/wallet';
  static const String walletTransactions = '/wallet/transactions';
  static const String addFunds = '/wallet/add-funds';
  static const String redeemWallet = '/wallet/redeem';

  // Promo Codes
  static const String validatePromoCode = '/promo-codes/validate';
  static const String userPromoCodes = '/user/promo-codes';
  static const String applyPromoCode = '/orders/{id}/apply-promo';

  // Banners
  static const String banners = '/banners';

  // Notifications
  static const String notificationPreferences = '/notification-preferences';
  static const String updateNotificationPrefs = '/notification-preferences';

  // ===== MISSING ENDPOINTS (TODO: Add when backend is ready) =====
  // Search
  // static const String searchProducts = '/products/search';
  // static const String searchSuggestions = '/products/search/suggestions';

  // Brands
  // static const String brands = '/brands';
  // static const String brandProducts = '/brands/{id}/products';

  // Flash Sales
  // static const String flashSales = '/flash-sales/active';
  // static const String flashSaleProducts = '/flash-sales/{id}/products';

  // Forgot Password
  // static const String forgotPassword = '/user/forgot-password';
  // static const String resetPassword = '/user/reset-password';
  // static const String changePassword = '/user/change-password';

  // Newsletter
  // static const String newsletterSubscribe = '/newsletter/subscribe';

  // User Notifications
  // static const String userNotifications = '/user/notifications';

  // Recently Viewed
  // static const String recentlyViewed = '/user/recently-viewed';
}
