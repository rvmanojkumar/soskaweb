import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TopHeader extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showBackButton;
  final String? title;
  final List<Widget>? actions;

  const TopHeader({
    Key? key,
    this.scaffoldKey,
    this.showBackButton = false,
    this.title,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 800;

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Back button (for non-home pages)
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),

          // Logo
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: const Text(
              'SOSKA',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 24),

          // Desktop Navigation Links
          if (isDesktop) ..._buildDesktopNavLinks(context),

          // Page Title (for mobile when there's a back button)
          if (!isDesktop && title != null) ...[
            const Spacer(),
            Text(
              title!,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const Spacer(),

          // Search Icon / Search Bar (desktop)
          if (isDesktop) _buildDesktopSearch(context),

          // Cart Icon
          _buildCartIcon(context),

          // User Icon (profile/login)
          _buildUserIcon(context),

          // Burger Menu (mobile)
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => scaffoldKey?.currentState?.openDrawer(),
            ),

          // Custom actions
          if (actions != null) ...actions!,
        ],
      ),
    );
  }

  List<Widget> _buildDesktopNavLinks(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/products');
        },
        child:
            const Text('Shop', style: TextStyle(color: AppColors.textPrimary)),
      ),
      const SizedBox(width: 16),
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/categories');
        },
        child: const Text('Categories',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
      const SizedBox(width: 16),
      TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/offers');
        },
        child: const Text('Offers',
            style: TextStyle(color: AppColors.textPrimary)),
      ),
    ];
  }

  Widget _buildDesktopSearch(BuildContext context) {
    return Container(
      width: 300,
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for products...',
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
        onSubmitted: (query) {
          Navigator.pushNamed(
            context,
            '/search',
            arguments: {'query': query},
          );
        },
      ),
    );
  }

  Widget _buildCartIcon(BuildContext context) {
    // TODO: Get cart item count from CartProvider
    final itemCount = 0; // Placeholder

    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        if (itemCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$itemCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUserIcon(BuildContext context) {
    // TODO: Check auth state from AuthProvider
    final isLoggedIn = false;

    return IconButton(
      icon: Icon(isLoggedIn ? Icons.person : Icons.person_outline),
      onPressed: () {
        if (isLoggedIn) {
          Navigator.pushNamed(context, '/profile');
        } else {
          Navigator.pushNamed(context, '/login');
        }
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
