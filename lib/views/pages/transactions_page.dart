import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../repositories/transaction_repository.dart';
import '../../viewmodels/transaction/transaction_cubit.dart';
import '../widgets/transaction_list_item.dart';

class TransactionsPageWrapper extends StatelessWidget {
  const TransactionsPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return TransactionCubit(TransactionRepository(ApiClient()))..onInitial();
      },
      child: const TransactionsPage(),
    );
  }
}

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TransactionCubit>();
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: BlocBuilder<TransactionCubit, TransactionState>(
        builder: (context, state) {
          final activeFilter =
              state is TransactionLoaded ? state.filter : 'all';
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: ['all', 'income', 'expense'].map((f) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(f[0].toUpperCase() + f.substring(1)),
                        selected: activeFilter == f,
                        onSelected: (_) {
                          cubit.setFilter(f);
                        },
                        selectedColor: AppTheme.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppTheme.primary,
                      ),
                    );
                  }).toList(),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state is TransactionLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is TransactionError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is TransactionLoaded) {
                      final list = state.filteredTransactions;
                      if (list.isEmpty) {
                        return const Center(
                            child: Text('No transactions found.',
                                style: TextStyle(
                                    color: AppTheme.textSecondary)));
                      }
                      return RefreshIndicator(
                        onRefresh: () {
                          return cubit.loadTransactions();
                        },
                        child: ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: list.length,
                          itemBuilder: (context, i) {
                            return TransactionListItem(
                              transaction: list[i],
                              onDelete: () {
                                cubit.removeTransaction(list[i].id);
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(AppRoutes.addTransaction);
          if (context.mounted) cubit.loadTransactions();
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
