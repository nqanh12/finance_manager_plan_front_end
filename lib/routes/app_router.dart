import 'package:finance_manager_plan_front_end/screens/categories_screen.dart';
import 'package:finance_manager_plan_front_end/screens/category_detail_screen.dart';
import 'package:finance_manager_plan_front_end/screens/wallets_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/transactions_screen.dart';
import '../screens/transaction_detail_screen.dart';
import '../screens/add_edit_transaction_screen.dart';
import '../screens/wallet_detail_screen.dart';
import '../screens/budgets_screen.dart';
import '../screens/budget_detail_screen.dart';
import '../screens/reports_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/profile_screen.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_scaffold.dart';
import '../models/index.dart';
import 'route_names.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: RouteNames.login,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isAuthRoute = state.matchedLocation == RouteNames.login || 
                         state.matchedLocation == RouteNames.register;

      if (!isLoggedIn && !isAuthRoute) {
        return RouteNames.login;
      }

      if (isLoggedIn && isAuthRoute) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: RouteNames.transactions,
            name: 'transactions',
            builder: (context, state) => const TransactionsScreen(),
          ),
          GoRoute(
            path: '/transaction/:id',
            name: 'transaction_detail',
            builder: (context, state) => TransactionDetailScreen(
              transactionId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: RouteNames.addTransaction,
            name: 'add_transaction',
            builder: (context, state) => const AddEditTransactionScreen(),
          ),
          GoRoute(
            path: '/transaction/:id/edit',
            name: 'edit_transaction',
            builder: (context, state) => AddEditTransactionScreen(
              transaction: state.extra as Transaction,
            ),
          ),
          GoRoute(
            path: RouteNames.wallets,
            name: '/wallet',
            builder: (context, state) => const WalletsScreen(),
          ),
          GoRoute(
            path: '/wallet/:id',
            name: 'walletDetail',
            builder: (context, state) => WalletDetailScreen(walletId: int.parse(state.pathParameters['id']!)),
          ),
          GoRoute(
            path: RouteNames.categories,
            name: 'categories',
            builder: (context, state) => const CategoriesScreen(),
          ),
          GoRoute(
            path: '/category/:id',
            name: 'category_detail', 
            builder: (context, state) => CategoryDetailScreen(
              categoryId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: RouteNames.budgets,
            name: 'budgets',
            builder: (context, state) => const BudgetsScreen(),
          ),
          GoRoute(
            path: '/budget/:id',
            name: 'budget_detail',
            builder: (context, state) => BudgetDetailScreen(
              budgetId: int.parse(state.pathParameters['id']!),
            ),
          ),
          GoRoute(
            path: RouteNames.reports,
            name: 'reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: RouteNames.settings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: RouteNames.profile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          )
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Error: ${state.error}',
          style: const TextStyle(color: Colors.red),
        ),
      ),
    ),
  );
}); 