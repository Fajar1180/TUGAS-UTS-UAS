import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_controller.dart';
import '../auth/login_page.dart';
import 'catalog_providers.dart';
import 'catalog_page.dart';
import 'my_orders_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TukangDekat'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Beranda'),
              Tab(icon: Icon(Icons.receipt_long), text: 'Pesanan'),
              Tab(icon: Icon(Icons.account_circle), text: 'Akun'),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Logout',
              onPressed: () async {
                await ref.read(authControllerProvider.notifier).logout();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (_) => false,
                );
              },
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            const CatalogPage(),
            const MyOrdersPage(),
            _buildAccountTab(context, state),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountTab(BuildContext context, dynamic state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            'Profil Akun',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${state.userEmail ?? 'N/A'}'),
                  const SizedBox(height: 8),
                  Text('Role: ${state.userRole ?? 'N/A'}'),
                  const SizedBox(height: 8),
                  Text('ID: ${state.userId ?? 'N/A'}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}