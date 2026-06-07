import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'core/network/api_client.dart';
import 'core/router/app_router.dart';
import 'repositories/auth_repository.dart';
import 'viewmodels/auth/auth_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // AuthCubit stays app-wide: logout + the router's auth redirect depend on
    // it. Feature cubits are provided per-page by their PageWrappers.
    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(AuthRepository(ApiClient())),
      child: Builder(
        builder: (context) {
          final router = AppRouter.createRouter(context);
          return MaterialApp.router(
            title: 'Finance Tracker',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            routerConfig: router,  // ← GoRouter wired here
          );
        },
      ),
    );
  }
}
