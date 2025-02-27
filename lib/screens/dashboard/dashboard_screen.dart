// lib/screens/dashboard/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/investment_provider.dart';
import '../../providers/tax_provider.dart';
import '../../widgets/common/app_drawer.dart';
import '../../widgets/common/loading_indicator.dart';
import 'overview_section.dart';
import 'expenses_section.dart';
import 'investments_section.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load data from providers
      await Future.wait([
        Provider.of<TransactionProvider>(context, listen: false)
            .fetchRecentTransactions(),
        Provider.of<InvestmentProvider>(context, listen: false)
            .fetchInvestmentSummary(),
        Provider.of<TaxProvider>(context, listen: false).fetchTaxStatus(),
      ]);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Failed to load dashboard data: ${error.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Finance Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDashboardData,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Navigate to notifications
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Expenses', icon: Icon(Icons.money_off)),
            Tab(text: 'Investments', icon: Icon(Icons.trending_up)),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const LoadingIndicator()
          : RefreshIndicator(
              onRefresh: _loadDashboardData,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  OverviewSection(),
                  ExpensesSection(),
                  InvestmentsSection(),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show dialog to add transaction/investment
          _showQuickAddDialog(context);
        },
        child: const Icon(Icons.add),
        tooltip: 'Quick Add',
      ),
    );
  }

  void _showQuickAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Quick Add',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text('Add Transaction'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/transactions/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_balance),
                title: const Text('Add Investment'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/investments/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload Document'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/tax-returns/upload');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
