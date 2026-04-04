import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/category.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    await categoryProvider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: categoryProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : categoryProvider.categories.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 80,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No categories found',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
              : _buildCategoryTree(context, categoryProvider),
    );
  }

  Widget _buildCategoryTree(BuildContext context, CategoryProvider provider) {
    // Get parent categories (those with no parent)
    final parentCategories = provider.parentCategories;

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: parentCategories.length,
      itemBuilder: (context, index) {
        final category = parentCategories[index];
        final subcategories = provider.getSubcategories(category.id);

        return Card(
          margin: EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Parent Category
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getCategoryIcon(category.name),
                    color: AppColors.primary,
                  ),
                ),
                title: Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                //subtitle: Text('${category.productCount} products'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/category-products',
                    arguments: {
                      'categoryId': category.id,
                      'categoryName': category.name,
                    },
                  );
                },
              ),

              // Subcategories
              if (subcategories.isNotEmpty) ...[
                Divider(),
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: subcategories.map((subcategory) {
                      return ActionChip(
                        label: Text(subcategory.name),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/category-products',
                            arguments: {
                              'categoryId': subcategory.id,
                              'categoryName': subcategory.name,
                            },
                          );
                        },
                        backgroundColor: Colors.grey[100],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'electronics':
        return Icons.devices;
      case 'clothing':
        return Icons.checkroom;
      case 'accessories':
        return Icons.watch;
      case 'home':
        return Icons.home;
      case 'beauty':
        return Icons.spa;
      case 'sports':
        return Icons.sports;
      default:
        return Icons.category;
    }
  }
}
