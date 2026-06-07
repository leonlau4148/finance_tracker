import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../models/transaction_model.dart';
import '../../repositories/category_repository.dart';
import '../../repositories/transaction_repository.dart';
import '../../viewmodels/add_transaction/add_transaction_cubit.dart';

class AddTransactionPageWrapper extends StatelessWidget {
  final TransactionModel? transaction; // null = add, non-null = edit

  const AddTransactionPageWrapper({super.key, this.transaction});

  @override
  Widget build(BuildContext context) {
    final api = ApiClient();
    return BlocProvider(
      create: (context) {
        return AddTransactionCubit(
          CategoryRepository(api),
          TransactionRepository(api),
        )..onInitial(transaction);
      },
      child: const AddTransactionPage(),
    );
  }
}

class AddTransactionPage extends StatelessWidget {
  const AddTransactionPage({super.key});

  Future<void> _pickDate(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    final picked = await showDatePicker(
      context: context,
      initialDate: cubit.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) cubit.setDate(picked);
  }

  void _submit(BuildContext context) async {
    final cubit = context.read<AddTransactionCubit>();
    if (!cubit.formKey.currentState!.validate()) return;
    if (cubit.categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a category')));
      return;
    }
    final ok = await cubit.submit();
    if (!context.mounted) return;
    final state = cubit.state;
    if (ok) {
      context.pop();
    } else if (state is AddTransactionError) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(state.message),
        backgroundColor: AppTheme.expense,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddTransactionCubit>();
    return BlocBuilder<AddTransactionCubit, AddTransactionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(cubit.isEdit ? 'Edit Transaction' : 'Add Transaction'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type toggle
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: ['expense', 'income'].map((type) {
                        final selected = cubit.type == type;
                        final color = type == 'income'
                            ? AppTheme.income
                            : AppTheme.expense;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              cubit.setType(type);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: selected ? color : Colors.transparent,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Text(
                                type[0].toUpperCase() + type.substring(1),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : AppTheme.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Amount
                  TextFormField(
                    controller: cubit.amountCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixIcon: Icon(Icons.attach_money)),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Enter an amount';
                      if (double.tryParse(v) == null) {
                        return 'Enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Description
                  TextFormField(
                    controller: cubit.descCtrl,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.notes)),
                    validator: (v) {
                      return v == null || v.isEmpty
                          ? 'Enter a description'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Category
                  DropdownButtonFormField<int>(
                    initialValue: cubit.categoryId,
                    decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined)),
                    items: cubit.categoriesForType
                        .map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text('${c.icon} ${c.name}'),
                          );
                        })
                        .toList(),
                    onChanged: cubit.setCategory,
                    hint: const Text('Select category'),
                  ),
                  const SizedBox(height: 16),
                  // Date picker
                  GestureDetector(
                    onTap: () {
                      _pickDate(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              color: AppTheme.textSecondary),
                          const SizedBox(width: 12),
                          Text(
                            '${cubit.date.day}/${cubit.date.month}/${cubit.date.year}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: state is AddTransactionSubmitting
                        ? null
                        : () {
                            _submit(context);
                          },
                    child: Text(cubit.isEdit
                        ? 'Update Transaction'
                        : 'Save Transaction'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
