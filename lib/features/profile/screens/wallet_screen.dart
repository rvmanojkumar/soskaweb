import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/models/wallet.dart';

class WalletScreen extends StatefulWidget {
  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    await profileProvider.loadWallet();
    await profileProvider.loadWalletTransactions();
  }
  
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text('My Wallet')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Balance Card
              Container(
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Available Balance',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '\$${authProvider.walletBalance.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _showAddFundsDialog(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                      ),
                      child: Text('ADD FUNDS'),
                    ),
                  ],
                ),
              ),
              
              // Transactions
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction History',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text('View All'),
                    ),
                  ],
                ),
              ),
              
              if (profileProvider.isLoadingTransactions)
                Center(child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ))
              else if (profileProvider.transactions.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No transactions yet'),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemCount: profileProvider.transactions.length > 10 ? 10 : profileProvider.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = profileProvider.transactions[index];
                    return _buildTransactionItem(transaction);
                  },
                ),
              
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildTransactionItem(Transaction transaction) {
    final isCredit = transaction.type == 'credit';
    final icon = isCredit ? Icons.arrow_downward : Icons.arrow_upward;
    final color = isCredit ? Colors.green : Colors.red;
    
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(transaction.description),
        subtitle: Text(_formatDate(transaction.createdAt)),
        trailing: Text(
          '${isCredit ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }
  
  void _showAddFundsDialog() {
    double amount = 0;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Funds'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: '\$ ',
                border: OutlineInputBorder(),
                hintText: 'Enter amount',
              ),
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: Text('\$10'))),
                SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: () {}, child: Text('\$50'))),
                SizedBox(width: 8),
                Expanded(child: OutlinedButton(onPressed: () {}, child: Text('\$100'))),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Handle add funds
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
  
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    
    if (diff.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (diff.inDays > 0) {
      return '${diff.inDays} days ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hours ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}