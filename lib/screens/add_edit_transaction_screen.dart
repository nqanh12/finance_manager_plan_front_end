import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/index.dart';
import '../providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_card.dart';

class AddEditTransactionScreen extends ConsumerStatefulWidget {
  final Transaction? transaction;

  const AddEditTransactionScreen({
    super.key,
    this.transaction,
  });

  @override
  ConsumerState<AddEditTransactionScreen> createState() =>
      _AddEditTransactionScreenState();
}

class _AddEditTransactionScreenState
    extends ConsumerState<AddEditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TransactionType _type;
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  int? _selectedCategoryId;
  int? _selectedWalletId;

  @override
  void initState() {
    super.initState();
    _type = widget.transaction?.type ?? TransactionType.expense;
    _amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );
    _noteController = TextEditingController(
      text: widget.transaction?.note ?? '',
    );
    _selectedDate = widget.transaction?.date ?? DateTime.now();
    _selectedCategoryId = widget.transaction?.categoryId;
    _selectedWalletId = widget.transaction?.walletId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final transaction = Transaction(
      id: widget.transaction?.id ?? 0, // Backend will handle ID for new transactions
      userId: 1, // TODO: Get from auth provider
      walletId: _selectedWalletId,
      categoryId: _selectedCategoryId,
      amount: double.parse(_amountController.text),
      type: _type,
      date: _selectedDate,
      note: _noteController.text.isEmpty ? null : _noteController.text,
    );

    try {
      if (widget.transaction == null) {
        await ref.read(transactionProvider.notifier).addTransaction(transaction);
      } else {
        await ref.read(transactionProvider.notifier).updateTransaction(transaction);
      }
      if (mounted) {
        context.pop(); // Return to previous screen
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final isDesktop = size.width > 1200;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.transaction == null ? 'Add Transaction' : 'Edit Transaction',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Transaction Type
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transaction Type',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<TransactionType>(
                        segments: const [
                          ButtonSegment<TransactionType>(
                            value: TransactionType.expense,
                            label: Text('Expense'),
                            icon: Icon(Icons.arrow_upward),
                          ),
                          ButtonSegment<TransactionType>(
                            value: TransactionType.income,
                            label: Text('Income'),
                            icon: Icon(Icons.arrow_downward),
                          ),
                        ],
                        selected: {_type},
                        onSelectionChanged: (Set<TransactionType> selected) {
                          setState(() {
                            _type = selected.first;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Amount
                CustomCard(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      prefixIcon: Icon(Icons.attach_money),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Date
                CustomCard(
                  child: ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date'),
                    subtitle: Text(
                      _selectedDate.toString().split(' ')[0],
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 16),

                // Category
                CustomCard(
                  child: ListTile(
                    leading: const Icon(Icons.category),
                    title: const Text('Category'),
                    subtitle: Text(
                      _selectedCategoryId == null
                          ? 'Select a category'
                          : 'Food & Drinks', // TODO: Get from category provider
                    ),
                    onTap: () {
                      // TODO: Show category selection dialog
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Wallet
                CustomCard(
                  child: ListTile(
                    leading: const Icon(Icons.account_balance_wallet),
                    title: const Text('Wallet'),
                    subtitle: Text(
                      _selectedWalletId == null
                          ? 'Select a wallet'
                          : 'Main Wallet', // TODO: Get from wallet provider
                    ),
                    onTap: () {
                      // TODO: Show wallet selection dialog
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Note
                CustomCard(
                  child: TextFormField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Note (Optional)',
                      prefixIcon: Icon(Icons.note),
                      alignLabelWithHint: true,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                CustomButton(
                  onPressed: _handleSubmit,
                  text: widget.transaction == null ? 'Add Transaction' : 'Save Changes',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 