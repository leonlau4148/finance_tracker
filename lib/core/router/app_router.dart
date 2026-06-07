import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_routes.dart';
import '../utils/token_storage.dart';
import '../../views/pages/login_page.dart';
import '../../views/pages/register_page.dart';
import '../../views/pages/dashboard_page.dart';
import '../../views/pages/transactions_page.dart';
import '../../views/pages/add_transaction_page.dart';
import '../../views/pages/categories_page.dart';
import '../../models/transaction_model.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: AppRoutes.login,
      redirect: (context, state) async {
        final hasToken = await TokenStorage.hasToken();
        final isAuthRoute = state.matchedLocation == AppRoutes.login ||
            state.matchedLocation == AppRoutes.register;

        if (!hasToken && !isAuthRoute) return AppRoutes.login;
        if (hasToken && isAuthRoute) return AppRoutes.dashboard;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginPageWrapper(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: 'register',
          builder: (context, state) => const RegisterPageWrapper(),
        ),
        GoRoute(
          path: AppRoutes.dashboard,
          name: 'dashboard',
          builder: (context, state) => const DashboardPageWrapper(),
        ),
        GoRoute(
          path: AppRoutes.transactions,
          name: 'transactions',
          builder: (context, state) => const TransactionsPageWrapper(),
        ),
        GoRoute(
          path: AppRoutes.addTransaction,
          name: 'addTransaction',
          builder: (context, state) => const AddTransactionPageWrapper(),
        ),
        GoRoute(
          path: '${AppRoutes.editTransaction}/:id',
          name: 'editTransaction',
          builder: (context, state) {
            final transaction = state.extra as TransactionModel;
            return AddTransactionPageWrapper(transaction: transaction);
          },
        ),
        GoRoute(
          path: AppRoutes.categories,
          name: 'categories',
          builder: (context, state) => const CategoriesPageWrapper(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(child: Text('Page not found: ${state.error}')),
      ),
    );
  }
}
