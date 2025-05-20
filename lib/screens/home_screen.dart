import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../routes/route_names.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;

    // Mock data
    final mockTransactions = [
      Transaction(
        id: 1,
        userId: 1,
        amount: 100.0,
        type: TransactionType.income,
        date: DateTime.now(),
        note: "Salary",
        categoryId: 1,
        walletId: 1,
      ),
      Transaction(
        id: 2,
        userId: 1,
        amount: 50.0,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 1)),
        note: "Groceries",
        categoryId: 2,
        walletId: 1,
      ),
      Transaction(
        id: 3,
        userId: 1,
        amount: 30.0,
        type: TransactionType.expense,
        date: DateTime.now().subtract(const Duration(days: 2)),
        note: "Transportation",
        categoryId: 3,
        walletId: 1,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with greeting and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back,',
                        style: TextStyle(
                          fontSize: isDesktop ? 24 : 20,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'John Doe',
                        style: TextStyle(
                          fontSize: isDesktop ? 32 : 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: isDesktop ? 32 : 24,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      'JD',
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Total Balance Card
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$12,345.67',
                      style: TextStyle(
                        fontSize: isDesktop ? 36 : 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: isDesktop ? 16 : 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '+\$1,234.56',
                                style: TextStyle(
                                  fontSize: isDesktop ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontSize: isDesktop ? 16 : 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '-\$567.89',
                                style: TextStyle(
                                  fontSize: isDesktop ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick Actions
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: isDesktop ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop ? 4 : isTablet ? 3 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildQuickActionCard(
                    context,
                    icon: Icons.add_circle_outline,
                    title: 'Add Income',
                    color: Colors.green,
                    onTap: () => context.push(RouteNames.addTransaction),
                  ),
                  _buildQuickActionCard(
                    context,
                    icon: Icons.remove_circle_outline,
                    title: 'Add Expense',
                    color: Colors.red,
                    onTap: () => context.push(RouteNames.addTransaction),
                  ),
                  _buildQuickActionCard(
                    context,
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Manage Wallets',
                    color: AppTheme.primaryColor,
                    onTap: () => context.push(RouteNames.wallets),
                  ),
                  _buildQuickActionCard(
                    context,
                    icon: Icons.savings_outlined,
                    title: 'Add Goal',
                    color: Colors.orange,
                    onTap: () => context.push(RouteNames.goals),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Recent Transactions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: isDesktop ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.secondaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(RouteNames.transactions),
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = mockTransactions[index];
                  return _buildTransactionItem(
                    context,
                    ref: ref,
                    transaction: transaction,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return CustomCard(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    BuildContext context, {
    required WidgetRef ref,
    required Transaction transaction,
  }) {
    final isIncome = transaction.type == TransactionType.income;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: isIncome ? Colors.green[100] : Colors.red[100],
        child: Icon(
          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      title: Text(
        transaction.note ?? (isIncome ? 'Income' : 'Expense'),
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        transaction.date.toString().split(' ')[0],
      ),
      trailing: Text(
        '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isIncome ? Colors.green : Colors.red,
        ),
      ),
      onTap: () => context.push('/transaction/${transaction.id}'),
    );
  }
}