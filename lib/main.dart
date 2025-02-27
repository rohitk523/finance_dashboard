// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'services/auth_service.dart';
import 'services/transaction_service.dart';
import 'services/investment_service.dart';
import 'services/tax_service.dart';
import 'services/ai_assistant_service.dart';
import 'providers/auth_provider.dart';
import 'providers/transaction_provider.dart';
import 'providers/investment_provider.dart';
import 'providers/tax_provider.dart';
import 'providers/document_provider.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize Dio with common configurations
  final dio = Dio();

  // Add interceptors for token management, logging, etc.
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Add auth token to all requests except login and register
      if (!options.path.contains('/auth/login') &&
          !options.path.contains('/auth/register')) {
        final token = prefs.getString('authToken');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      // Handle token expiration
      if (e.response?.statusCode == 401) {
        // Clear token and redirect to login
        prefs.remove('authToken');
        prefs.remove('user');
      }
      return handler.next(e);
    },
  ));

  // Initialize services
  final authService = AuthService(dio);
  final transactionService = TransactionService(dio);
  final investmentService = InvestmentService(dio);
  final taxService = TaxService(dio);
  final aiAssistantService = AIAssistantService(dio);

  runApp(MyApp(
    authService: authService,
    transactionService: transactionService,
    investmentService: investmentService,
    taxService: taxService,
    aiAssistantService: aiAssistantService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final TransactionService transactionService;
  final InvestmentService investmentService;
  final TaxService taxService;
  final AIAssistantService aiAssistantService;

  const MyApp({
    Key? key,
    required this.authService,
    required this.transactionService,
    required this.investmentService,
    required this.taxService,
    required this.aiAssistantService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(transactionService),
        ),
        ChangeNotifierProvider(
          create: (_) => InvestmentProvider(investmentService),
        ),
        ChangeNotifierProvider(
          create: (_) => TaxProvider(taxService),
        ),
        ChangeNotifierProvider(
          create: (_) => DocumentProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return MaterialApp(
            title: 'Finance Dashboard',
            theme: AppTheme.lightTheme(),
            // initialRoute: authProvider.isAuthenticated
            //     ? DashboardScreen.routeName
            //     : LoginScreen.routeName,
            // Bypassing for now:
            home: const DashboardScreen(),
            routes: AppRoutes.routes,
            onGenerateRoute: AppRoutes.generateRoute,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
