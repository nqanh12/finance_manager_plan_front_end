import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../routes/route_names.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  String _searchQuery = '';
  String _filterType = 'all';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;

    // Mock data
    final mockTransactions = [
      Transaction(
        id: 1,
        userId: 1,
        amount: 2500.0,
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
      Transaction(
        id: 4,
        userId: 1,
        amount: 100.0,
        type: TransactionType.income,
        date: DateTime.now().subtract(const Duration(days: 3)),
        note: "Freelance work",
        categoryId: 1,
        walletId: 2,
      ),
    ];

    // Calculate totals from mock data
    final totalIncome = mockTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
    
    final totalExpenses = mockTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    // Filter transactions
    final filteredTransactions = mockTransactions.where((transaction) {
      final matchesSearch = transaction.note?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false;
      final matchesFilter = _filterType == 'all' ||
          (_filterType == 'income' && transaction.type == TransactionType.income) ||
          (_filterType == 'expense' && transaction.type == TransactionType.expense);
      return matchesSearch || matchesFilter;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Transactions',
                style: TextStyle(
                  fontSize: isDesktop ? 32 : 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(height: 24),

              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: CustomCard(
                      color: Colors.green[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: const Icon(
                                  Icons.arrow_downward,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Income',
                                style: TextStyle(
                                  fontSize: isDesktop ? 18 : 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '+\$${totalIncome.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: isDesktop ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomCard(
                      color: Colors.red[50],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.red[100],
                                child: const Icon(
                                  Icons.arrow_upward,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Expenses',
                                style: TextStyle(
                                  fontSize: isDesktop ? 18 : 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '-\$${totalExpenses.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: isDesktop ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Filter Section
              CustomCard(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search transactions',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    PopupMenuButton<String>(
                      initialValue: _filterType,
                      child: CustomCard(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.filter_list),
                              SizedBox(width: 8),
                              Text('Filter'),
                            ],
                          ),
                        ),
                      ),
                      onSelected: (value) {
                        setState(() {
                          _filterType = value;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'all',
                          child: Text('All'),
                        ),
                        const PopupMenuItem(
                          value: 'income',
                          child: Text('Income'),
                        ),
                        const PopupMenuItem(
                          value: 'expense',
                          child: Text('Expense'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Transactions List
              if (filteredTransactions.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredTransactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = filteredTransactions[index];
                    final isIncome = transaction.type == TransactionType.income;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isIncome 
                          ? Colors.green[100] 
                          : Colors.red[100],
                        child: Icon(
                          isIncome 
                            ? Icons.arrow_downward 
                            : Icons.arrow_upward,
                          color: isIncome ? Colors.green : Colors.red,
                        ),
                      ),
                      title: Text(
                        transaction.note ?? (isIncome ? 'Income' : 'Expense'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category: ${transaction.categoryId ?? 'Uncategorized'}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            transaction.date.toString().split(' ')[0],
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isIncome ? Colors.green : Colors.red,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () {
                        context.push('/transaction/${transaction.id}', extra: transaction);
                      },
                    );
                  },
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(RouteNames.addTransaction),
        child: const Icon(Icons.add),
      ),
    );
  }
}