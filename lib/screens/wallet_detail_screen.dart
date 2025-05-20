import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../providers/wallet_provider.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_button.dart';
import '../routes/route_names.dart';

class WalletDetailScreen extends ConsumerWidget {
  final int walletId;

  const WalletDetailScreen({
    super.key,
    required this.walletId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletsState = ref.watch(walletProvider);
    final wallet = walletsState.whenData((wallets) {
      return wallets.firstWhere((w) => w.id == walletId);
    }).value;

    final transactionsState = ref.watch(transactionProvider);
    final walletTransactions = transactionsState.whenData((transactions) {
      return transactions.where((t) => t.walletId == walletId).toList();
    }).value;

    if (wallet == null) {
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
        title: Text(wallet.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _showEditWalletDialog(context, ref, wallet);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmation(context, ref, wallet);
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
              // Wallet Balance Card
              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                          child: const Icon(
                            Icons.account_balance_wallet,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Current Balance',
                          style: TextStyle(
                            fontSize: isDesktop ? 20 : 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '\$${wallet.balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: isDesktop ? 36 : 28,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              context.push(RouteNames.addTransaction);
                            },
                            text: 'Add Transaction',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recent Transactions
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: isDesktop ? 24 : 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.secondaryColor,
                ),
              ),
              const SizedBox(height: 16),

              if (walletTransactions == null)
                const Center(child: CircularProgressIndicator())
              else if (walletTransactions.isEmpty)
                CustomCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No transactions yet',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            context.push(RouteNames.addTransaction);
                          },
                          child: const Text('Add your first transaction'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: walletTransactions.length > 5 ? 5 : walletTransactions.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final transaction = walletTransactions[index];
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
                      onTap: () {
                        context.push('/transaction/${transaction.id}', extra: transaction);
                      },
                    );
                  },
                ),
              
              if (walletTransactions != null && walletTransactions.length > 5)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        context.push(RouteNames.transactions);
                      },
                      child: const Text('View all transactions'),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditWalletDialog(BuildContext context, WidgetRef ref, Wallet wallet) {
    showDialog(
      context: context,
      builder: (context) => EditWalletDialog(wallet: wallet),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, Wallet wallet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Wallet'),
        content: Text('Are you sure you want to delete ${wallet.name}? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref.read(walletProvider.notifier).deleteWallet(wallet.id);
                if (context.mounted) {
                  Navigator.pop(context);
                  context.pop();
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class EditWalletDialog extends ConsumerStatefulWidget {
  final Wallet wallet;

  const EditWalletDialog({
    super.key,
    required this.wallet,
  });

  @override
  ConsumerState<EditWalletDialog> createState() => _EditWalletDialogState();
}

class _EditWalletDialogState extends ConsumerState<EditWalletDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.wallet.name);
    _balanceController = TextEditingController(
      text: widget.wallet.balance.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Wallet'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Wallet Name',
                prefixIcon: Icon(Icons.account_balance_wallet),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a wallet name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _balanceController,
              decoration: const InputDecoration(
                labelText: 'Current Balance',
                prefixIcon: Icon(Icons.attach_money),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter current balance';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final updatedWallet = Wallet(
                id: widget.wallet.id,
                userId: widget.wallet.userId,
                name: _nameController.text,
                balance: double.parse(_balanceController.text),
              );

              try {
                await ref.read(walletProvider.notifier).updateWallet(updatedWallet);
                if (mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
} 