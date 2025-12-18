// lib/features/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_provider.dart';
import '../invoices/invoices_tab_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    // TODO: load data from API or mock data into provider if needed.
    // Example: provider.loadInvoices(mockInvoices);
    // Example: provider.loadPayments(mockPayments);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A2947),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderWithConsumer(),
              const SizedBox(height: 32),
              _buildGridMenu(),
              const SizedBox(height: 32),
              const Text(
                'Recent Activities',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _buildRecentActivitiesWithConsumer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderWithConsumer() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;
        final userName = user?.nickname ?? 'Guest';
        final userProfilePic =
            user?.profilePic ?? 'https://via.placeholder.com/60';

        return Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                image: DecorationImage(
                  image: NetworkImage(userProfilePic),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'Hi, $userName',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridMenu() {
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMenuCard(
          icon: Icons.shopping_cart_outlined,
          label: 'Browse\nStore',
          onTap: () => Navigator.pushNamed(context, '/browse-stores'),
        ),
        _buildMenuCard(
          icon: Icons.description_outlined,
          label: 'My\nInvoices',
          onTap: _navigateToInvoices,
        ),
        _buildMenuCard(
          icon: Icons.store_outlined,
          label: 'My\nStore',
          onTap: () => Navigator.pushNamed(context, '/my-store'),
        ),
        _buildMenuCard(
          icon: Icons.person_outline,
          label: 'Profile',
          onTap: _navigateToProfile,
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: const Color(0xFF1976D2)),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF1976D2),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitiesWithConsumer() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final activities = provider.getRecentActivities(limit: 10);

        if (activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined,
                    size: 64, color: Colors.white.withOpacity(0.3)),
                const SizedBox(height: 16),
                Text(
                  'No recent activities',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildActivityItemFromProvider(activity),
            );
          },
        );
      },
    );
  }

  Widget _buildActivityItemFromProvider(Map<String, dynamic> activity) {
    final type = activity['type'] as String;
    final description = activity['description'] as String;
    final date = activity['date'] as String;

    Color accentColor;
    IconData icon;
    String title;

    if (type == 'invoice') {
      accentColor = const Color(0xFF64B5F6);
      icon = Icons.receipt_long;
      title = 'Invoice $description';
    } else if (type == 'payment') {
      accentColor = const Color(0xFF4CAF50);
      icon = Icons.payment;
      title = 'Payment $description';
    } else {
      accentColor = const Color(0xFF64B5F6);
      icon = Icons.info_outline;
      title = description;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF263A5F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(_formatDate(date),
                    style: const TextStyle(
                        color: Color(0xFF90CAF9), fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return date;
    }
  }

  void _navigateToInvoices() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const InvoicesTabPage(),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/profile');
  }
}
