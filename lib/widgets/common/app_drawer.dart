// lib/widgets/common/app_drawer.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Drawer(
      child: Column(
        children: [
          _buildHeader(context, user),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  context,
                  title: 'Dashboard',
                  icon: Icons.dashboard,
                  routeName: '/dashboard',
                ),
                _buildNavItem(
                  context,
                  title: 'Transactions',
                  icon: Icons.receipt_long,
                  routeName: '/transactions',
                ),
                _buildNavItem(
                  context,
                  title: 'Investments',
                  icon: Icons.trending_up,
                  routeName: '/investments',
                ),
                _buildNavItem(
                  context,
                  title: 'Tax Returns',
                  icon: Icons.request_page,
                  routeName: '/tax-returns',
                ),
                _buildNavItem(
                  context,
                  title: 'Documents',
                  icon: Icons.folder,
                  routeName: '/documents',
                ),
                const Divider(),
                _buildNavItem(
                  context,
                  title: 'Financial Insights',
                  icon: Icons.insights,
                  routeName: '/insights',
                ),
                _buildNavItem(
                  context,
                  title: 'Tax Planner',
                  icon: Icons.savings,
                  routeName: '/tax-planner',
                ),
                _buildNavItem(
                  context,
                  title: 'AI Assistant',
                  icon: Icons.support_agent,
                  routeName: '/ai-assistant',
                ),
                const Divider(),
                _buildNavItem(
                  context,
                  title: 'Settings',
                  icon: Icons.settings,
                  routeName: '/settings',
                ),
                _buildNavItem(
                  context,
                  title: 'Profile',
                  icon: Icons.person,
                  routeName: '/profile',
                ),
                _buildNavItem(
                  context,
                  title: 'Help & Support',
                  icon: Icons.help,
                  routeName: '/help',
                ),
              ],
            ),
          ),
          _buildFooter(context, authProvider),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic>? user) {
    return UserAccountsDrawerHeader(
      accountName: Text(
        user?['name'] ?? 'User',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      accountEmail: Text(user?['email'] ?? 'user@example.com'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Text(
          (user?['name'] as String?)?.isNotEmpty == true
              ? (user!['name'] as String).substring(0, 1).toUpperCase()
              : 'U',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      otherAccountsPictures: [
        IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/profile');
          },
        ),
      ],
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String routeName,
    Widget? badge,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final isSelected = currentRoute == routeName;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : null,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: badge,
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        if (currentRoute != routeName) {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }

  Widget _buildFooter(BuildContext context, AuthProvider authProvider) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );

              if (confirmed == true) {
                await authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            'App Version 1.0.0',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
