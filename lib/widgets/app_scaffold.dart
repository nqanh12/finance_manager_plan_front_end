import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../routes/route_names.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;

  const AppScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.of(context).size.width >= 800,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.account_balance_wallet_outlined),
                selectedIcon: Icon(Icons.account_balance_wallet),
                label: Text('Wallet'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('Statistics'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.savings_outlined),
                selectedIcon: Icon(Icons.savings),
                label: Text('Budget'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.flag_outlined),
                selectedIcon: Icon(Icons.flag),
                label: Text('Goals'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings_outlined),
                selectedIcon: Icon(Icons.settings),
                label: Text('Settings'),
              ),
            ],
            selectedIndex: _calculateSelectedIndex(context),
            onDestinationSelected: (index) => _onItemTapped(index, context),
          ),
          Expanded(
            child: child,
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith(RouteNames.home)) return 0;
    if (location.startsWith(RouteNames.wallets)) return 1;
    if (location.startsWith(RouteNames.reports)) return 2;
    if (location.startsWith(RouteNames.budgets)) return 3;
    if (location.startsWith(RouteNames.goals)) return 4;
    if (location.startsWith(RouteNames.settings)) return 5;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.wallets);
        break;
      case 2:
        context.go(RouteNames.reports);
        break;
      case 3:
        context.go(RouteNames.budgets);
        break;
      case 4:
        context.go(RouteNames.goals);
        break;
      case 5:
        context.go(RouteNames.settings);
        break;
    }
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location == RouteNames.transactions) {
      return FloatingActionButton(
        onPressed: () => context.push(RouteNames.addTransaction),
        child: const Icon(Icons.add),
      );
    }
    return null;
  }
} 