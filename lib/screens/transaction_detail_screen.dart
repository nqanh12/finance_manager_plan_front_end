import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';
import '../routes/route_names.dart';

class TransactionDetailScreen extends ConsumerWidget {
  final int transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsState = ref.watch(transactionProvider);
    final transaction = transactionsState.whenData((transactions) {
      return transactions.firstWhere((t) => t.id == transactionId);
    }).value;

    if (transaction == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push(
                '/transaction/${transaction.id}/edit',
                extra: transaction,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: const Text(
                    'Are you sure you want to delete this transaction?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await ref
                    .read(transactionProvider.notifier)
                    .deleteTransaction(transaction.id);
                if (context.mounted) {
                  context.go(RouteNames.transactions); // Return to transactions list
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Amount Card
              CustomCard(
                color: transaction.type == TransactionType.income
                    ? Colors.green[50]
                    : Colors.red[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: transaction.type == TransactionType.income
                              ? Colors.green[100]
                              : Colors.red[100],
                          child: Icon(
                            transaction.type == TransactionType.income
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: transaction.type == TransactionType.income
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          transaction.type == TransactionType.income
                              ? 'Income'
                              : 'Expense',
                          style: TextStyle(
                            fontSize: isDesktop ? 18 : 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${transaction.type == TransactionType.income ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isDesktop ? 32 : 28,
                        fontWeight: FontWeight.bold,
                        color: transaction.type == TransactionType.income
                            ? Colors.green
                            : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Details
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context,
                      label: 'Date',
                      value: transaction.date.toString().split(' ')[0],
                      icon: Icons.calendar_today,
                    ),
                    const Divider(),
                    _buildDetailRow(
                      context,
                      label: 'Category',
                      value: 'Food & Drinks', // TODO: Get from category provider
                      icon: Icons.category,
                    ),
                    if (transaction.note != null) ...[
                      const Divider(),
                      _buildDetailRow(
                        context,
                        label: 'Note',
                        value: transaction.note!,
                        icon: Icons.note,
                      ),
                    ],
                    const Divider(),
                    _buildDetailRow(
                      context,
                      label: 'Wallet',
                      value: 'Main Wallet', // TODO: Get from wallet provider
                      icon: Icons.account_balance_wallet,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 