import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: EdgeInsets.all(24),
              color: AppColors.primary.withOpacity(0.1),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary,
                    child: Text(
                      user?.name[0].toUpperCase() ?? 'U',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user?.name ?? 'User',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(color: Colors.grey),
                  ),
                  if (user?.phone != null)
                    Text(
                      user!.phone!,
                      style: TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
            
            // Stats Cards
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.shopping_bag_outlined,
                      label: 'Orders',
                      value: '0',
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.favorite_border,
                      label: 'Wishlist',
                      value: '0',
                      onTap: () {
                        Navigator.pushNamed(context, '/wishlist');
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.account_balance_wallet,
                      label: 'Wallet',
                      value: '\$${authProvider.walletBalance.toStringAsFixed(2)}',
                      onTap: () {
                        Navigator.pushNamed(context, '/wallet');
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Menu Items
            Card(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'My Addresses',
                    onTap: () {
                      Navigator.pushNamed(context, '/addresses');
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Order History',
                    onTap: () {
                      // Navigate to orders
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      // Navigate to notifications
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () async {
                      await authProvider.logout();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    isDestructive: true,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, size: 28, color: AppColors.primary),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : AppColors.primary),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? Colors.red : null),
      ),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}