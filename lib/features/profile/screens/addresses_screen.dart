import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/address.dart';

class AddressesScreen extends StatefulWidget {
  @override
  _AddressesScreenState createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.loadAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Addresses'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddressForm(context),
          ),
        ],
      ),
      body: profileProvider.isLoadingAddresses
          ? Center(child: CircularProgressIndicator())
          : profileProvider.addresses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No addresses saved'),
                      SizedBox(height: 8),
                      Text('Add your first address'),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => _showAddressForm(context),
                        child: Text('Add Address'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: profileProvider.addresses.length,
                  itemBuilder: (context, index) {
                    final address = profileProvider.addresses[index];
                    return _buildAddressCard(context, address, profileProvider);
                  },
                ),
    );
  }

  Widget _buildAddressCard(
      BuildContext context, Address address, ProfileProvider profileProvider) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  address.addressType == 'home'
                      ? Icons.home
                      : address.addressType == 'work'
                          ? Icons.work
                          : Icons.location_on,
                  size: 20,
                  color: AppColors.primary,
                ),
                SizedBox(width: 8),
                Text(
                  address.addressType.toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                if (address.isDefault) ...[
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Default', style: TextStyle(fontSize: 10)),
                  ),
                ],
                Spacer(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _editAddress(context, address);
                    } else if (value == 'delete') {
                      _deleteAddress(context, address, profileProvider);
                    } else if (value == 'set_default') {
                      _setDefaultAddress(context, address, profileProvider);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(
                        value: 'set_default', child: Text('Set as Default')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(address.addressLine1),
            if (address.addressLine2 != null) Text(address.addressLine2!),
            Text('${address.city}, ${address.state} - ${address.postalCode}'),
            Text(address.country),
            Text('Phone: ${address.phone}'),
          ],
        ),
      ),
    );
  }

  void _showAddressForm(BuildContext context, [Address? address]) {
    // Simple form dialog for adding/editing address
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(address == null ? 'Add Address' : 'Edit Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  decoration: InputDecoration(labelText: 'Address Line 1')),
              TextField(
                  decoration: InputDecoration(labelText: 'Address Line 2')),
              TextField(decoration: InputDecoration(labelText: 'City')),
              TextField(decoration: InputDecoration(labelText: 'State')),
              TextField(decoration: InputDecoration(labelText: 'Postal Code')),
              TextField(decoration: InputDecoration(labelText: 'Country')),
              TextField(decoration: InputDecoration(labelText: 'Phone')),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(address == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _editAddress(BuildContext context, Address address) {
    _showAddressForm(context, address);
  }

  Future<void> _deleteAddress(BuildContext context, Address address,
      ProfileProvider profileProvider) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              await profileProvider.deleteAddress(address.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Address deleted')),
              );
            },
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Future<void> _setDefaultAddress(BuildContext context, Address address,
      ProfileProvider profileProvider) async {
    await profileProvider.updateAddress(address.id, {'is_default': true});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Default address updated')),
    );
  }
}
