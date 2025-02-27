// lib/config/routes.dart

import 'package:finance_dashboard/screens/setttings/preferences_screen.dart';
import 'package:finance_dashboard/screens/setttings/profile_screen.dart';
import 'package:finance_dashboard/screens/setttings/settings_screen.dart';
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';

import '../screens/transactions/transactions_screen.dart';
import '../screens/transactions/transaction_detail_screen.dart';
import '../screens/transactions/add_transaction_screen.dart';
import '../screens/investments/investments_screen.dart';
import '../screens/investments/investment_detail_screen.dart';
import '../screens/investments/add_investment_screen.dart';
import '../screens/tax_returns/tax_returns_screen.dart';
import '../screens/tax_returns/document_upload_screen.dart';
import '../screens/tax_returns/tax_calculation_screen.dart';
import '../screens/tax_returns/tax_review_screen.dart';

class AppRoutes {
  static const String initialRoute = '/';

  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const LoginScreen(),
    LoginScreen.routeName: (context) => const LoginScreen(),
    RegisterScreen.routeName: (context) => const RegisterScreen(),
    ForgotPasswordScreen.routeName: (context) => const ForgotPasswordScreen(),
    DashboardScreen.routeName: (context) => const DashboardScreen(),
    '/transactions': (context) => const TransactionsScreen(),
    '/transactions/detail': (context) => const TransactionDetailScreen(),
    '/transactions/add': (context) => const AddTransactionScreen(),
    '/transactions/edit': (context) =>
        const AddTransactionScreen(isEditing: true),
    '/investments': (context) => const InvestmentsScreen(),
    '/investments/detail': (context) => const InvestmentDetailScreen(),
    '/investments/add': (context) => const AddInvestmentScreen(),
    '/investments/edit': (context) =>
        const AddInvestmentScreen(isEditing: true),
    '/tax-returns': (context) => const TaxReturnsScreen(),
    '/tax-returns/upload': (context) => const DocumentUploadScreen(),
    '/tax-returns/calculate': (context) => const TaxCalculationScreen(),
    '/tax-returns/review': (context) => const TaxReviewScreen(),
    '/settings': (context) => const SettingsScreen(),
    '/profile': (context) => const ProfileScreen(),
    '/preferences': (context) => const PreferencesScreen(),
  };

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // For routes that need to pass arguments
    if (settings.name == '/transactions/detail') {
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => TransactionDetailScreen(
          transactionId: args as String,
        ),
      );
    } else if (settings.name == '/investments/detail') {
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => InvestmentDetailScreen(
          investmentId: args as String,
        ),
      );
    } else if (settings.name == '/transactions/edit') {
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => AddTransactionScreen(
          isEditing: true,
          transaction: args,
        ),
      );
    } else if (settings.name == '/investments/edit') {
      final args = settings.arguments;
      return MaterialPageRoute(
        builder: (context) => AddInvestmentScreen(
          isEditing: true,
          investment: args,
        ),
      );
    }

    // If not handled by the cases above, use the regular routes
    return MaterialPageRoute(
      builder: routes[settings.name] ?? (context) => const LoginScreen(),
    );
  }

  // Auth guard - redirects to login if not authenticated
  static Route<dynamic> guardedRoute(
    BuildContext context,
    Widget destination,
    bool isAuthenticated,
  ) {
    if (isAuthenticated) {
      return MaterialPageRoute(builder: (context) => destination);
    } else {
      return MaterialPageRoute(builder: (context) => const LoginScreen());
    }
  }
}
