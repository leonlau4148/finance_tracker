import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_theme.dart';
import '../../core/network/api_client.dart';
import '../../repositories/category_repository.dart';
import '../../viewmodels/category/category_cubit.dart';

class CategoriesPageWrapper extends StatelessWidget {
  const CategoriesPageWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CategoryCubit(CategoryRepository(ApiClient()))..onInitial();
      },
      child: const CategoriesPage(),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  void _showAddDialog(BuildContext context) {
    final cubit = context.read<CategoryCubit>();
    final nameCtrl = TextEditingController();
    final iconCtrl = TextEditingController();
    String type = 'expense';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialog) {
            return AlertDialog(
              title: const Text('New Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: iconCtrl,
                    decoration:
                        const InputDecoration(labelText: 'Icon (emoji)'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: ['expense', 'income'].map((t) {
                      return Expanded(
                        child: RadioListTile<String>(
                          title: Text(
                              t[0].toUpperCase() + t.substring(1)),
                          value: t,
                          groupValue: type,
                          onChanged: (v) {
                            setDialog(() {
                              type = v!;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isNotEmpty) {
                      cubit.addCategory(
                        nameCtrl.text.trim(),
                        type,
                        iconCtrl.text.trim(),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          final cubit = context.read<CategoryCubit>();
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryError) {
            return Center(child: Text(state.message));
          }
          if (state is CategoryLoaded) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _Section(
                    title: 'Expense Categories',
                    categories: cubit.expenses,
                    color: AppTheme.expense),
                const SizedBox(height: 16),
                _Section(
                    title: 'Income Categories',
                    categories: cubit.incomes,
                    color: AppTheme.income),
              ],
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDialog(context);
        },
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List categories;
  final Color color;

  const _Section({
    required this.title,
    required this.categories,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary)),
        const SizedBox(height: 8),
        if (categories.isEmpty)
          const Text('None yet.',
              style: TextStyle(color: AppTheme.textSecondary))
        else
          ...categories.map(
            (c) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: color.withOpacity(0.15),
                    child: Text(
                        c.icon.isNotEmpty ? c.icon : '📁',
                        style: const TextStyle(fontSize: 20)),
                  ),
                  title: Text(c.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: AppTheme.expense),
                    onPressed: () {
                      context.read<CategoryCubit>().removeCategory(c.id);
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
