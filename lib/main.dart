import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Core
import 'core/network/api_client.dart';

// Providers
import 'features/auth/providers/auth_provider.dart';
import 'features/cart/providers/cart_provider.dart';
import 'features/products/providers/product_provider.dart';
import 'features/wishlist/providers/wishlist_provider.dart';
import 'features/orders/providers/order_provider.dart';
import 'features/profile/providers/profile_provider.dart';
import 'features/shared/providers/theme_provider.dart';

// Screens
import 'features/home/screens/home_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/signup_screen.dart';
import 'features/auth/screens/forgot_password_screen.dart';
import 'features/products/screens/product_list_screen.dart';
import 'features/products/screens/product_detail_screen.dart';
import 'features/cart/screens/cart_screen.dart';
import 'features/orders/screens/checkout_screen.dart';
import 'features/orders/screens/order_detail_screen.dart';
import 'features/profile/screens/profile_screen.dart';
import 'features/profile/screens/addresses_screen.dart';
import 'features/profile/screens/wallet_screen.dart';
import 'features/wishlist/screens/wishlist_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize API client
  ApiClient().init();
  await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Soskali Lifestyles',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.themeData,
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            initialRoute: '/',
            onGenerateRoute: _generateRoute,
          );
        },
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());

      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case '/signup':
        return MaterialPageRoute(builder: (_) => SignupScreen());

      case '/forgot-password':
        return MaterialPageRoute(builder: (_) => ForgotPasswordScreen());

      case '/products':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProductListScreen(
            categoryId: args?['categoryId'],
            categoryName: args?['categoryName'],
          ),
        );

      case '/product':
        final args = settings.arguments as Map<String, dynamic>;
        // Make sure productId is passed correctly
        final productId = args['productId']?.toString() ?? '';
        return MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: productId),
        );

      case '/cart':
        return MaterialPageRoute(builder: (_) => CartScreen());

      case '/checkout':
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CheckoutScreen(),
        );

      case '/order-detail':
        final args = settings.arguments as Map<String, dynamic>;
        final orderId = args['orderId']?.toString() ?? '';
        return MaterialPageRoute(
          builder: (_) => OrderDetailScreen(orderId: orderId),
        );

      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());

      case '/addresses':
        return MaterialPageRoute(builder: (_) => AddressesScreen());

      case '/wallet':
        return MaterialPageRoute(builder: (_) => WalletScreen());

      case '/wishlist':
        return MaterialPageRoute(builder: (_) => WishlistScreen());

      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
