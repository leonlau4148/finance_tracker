import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_theme.dart';
import '../../core/constants/app_routes.dart';
import '../../models/transaction_model.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;
  final bool showEdit;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onDelete,
    this.showEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == 'income';
    final color = isIncome ? AppTheme.income : AppTheme.expense;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(
            isIncome
                ? Icons.arrow_downward_rounded
                : Icons.arrow_upward_rounded,
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary),
        ),
        subtitle: Text(
          '${transaction.category} · '
          '${transaction.transactionDate.day}/'
          '${transaction.transactionDate.month}/'
          '${transaction.transactionDate.year}',
          style: const TextStyle(
              fontSize: 12, color: AppTheme.textSecondary),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            if (showEdit)
              IconButton(
                icon: const Icon(Icons.edit_outlined,
                    color: AppTheme.textSecondary, size: 20),
                onPressed: () => context.push(
                  '${AppRoutes.editTransaction}/${transaction.id}',
                  extra: transaction,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: AppTheme.expense, size: 20),
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Delete Transaction'),
                  content: const Text(
                      'Are you sure you want to delete this?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onDelete();
                      },
                      child: const Text('Delete',
                          style: TextStyle(color: AppTheme.expense)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
