<<<<<<< HEAD
// lib/features/home/home_page.dart
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    // Initialize mock data when page loads
    _loadMockData();
  }

  // Load mock data into provider
  void _loadMockData() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    
    // You can load your data here from API or mock data
    // Example: provider.loadInvoices(invoicesList);
    // Example: provider.loadPayments(paymentsList);
=======
    _loadMockData();
  }

  void _loadMockData() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    // keep empty – safe for now
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    // Read provider data - use this for one-time reads
    final provider = Provider.of<AppProvider>(context);
    
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
    return Scaffold(
      backgroundColor: const Color(0xFF1A2947),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
<<<<<<< HEAD
              // Header with profile picture and greeting - Using Consumer
              _buildHeaderWithConsumer(),
              const SizedBox(height: 32),
              
              // Grid Menu (2x2)
              _buildGridMenu(),
              const SizedBox(height: 32),
              
              // Recent Activities Section
=======
              _buildHeaderWithConsumer(),
              const SizedBox(height: 32),
              _buildGridMenu(),
              const SizedBox(height: 32),
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
              const Text(
                'Recent Activities',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
<<<<<<< HEAD
              
              // Activities List - Using Consumer for dynamic updates
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
              Expanded(
                child: _buildRecentActivitiesWithConsumer(),
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  // Header Section - Using Consumer to react to user changes
  Widget _buildHeaderWithConsumer() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        // Get user data from provider
        final user = provider.currentUser;
        final userName = user?.nickname ?? 'Guest';
        final userProfilePic = user?.profilePic ?? 'https://via.placeholder.com/60';
        
        return Row(
          children: [
            // Profile Picture
=======
  Widget _buildHeaderWithConsumer() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final user = provider.currentUser;
        final userName = user?.nickname ?? 'Guest';
        final userProfilePic =
            user?.profilePic ?? 'https://via.placeholder.com/60';

        return Row(
          children: [
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
<<<<<<< HEAD
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
=======
                border: Border.all(color: Colors.white, width: 2),
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
                image: DecorationImage(
                  image: NetworkImage(userProfilePic),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
<<<<<<< HEAD
            // Greeting Text
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
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

<<<<<<< HEAD
  // Grid Menu Section (4 cards: Browse Store, My Invoices, My Store, Profile)
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
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
          onTap: () {
<<<<<<< HEAD
            _showComingSoon(context, 'Browse Store');
=======
            Navigator.pushNamed(context, '/browse-stores');
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
          },
        ),
        _buildMenuCard(
          icon: Icons.description_outlined,
          label: 'My\nInvoices',
<<<<<<< HEAD
          onTap: () {
            _navigateToInvoices();
          },
=======
          onTap: _navigateToInvoices,
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
        ),
        _buildMenuCard(
          icon: Icons.store_outlined,
          label: 'My\nStore',
          onTap: () {
<<<<<<< HEAD
            _showComingSoon(context, 'My Store');
=======
            Navigator.pushNamed(context, '/my-store');
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
          },
        ),
        _buildMenuCard(
          icon: Icons.person_outline,
          label: 'Profile',
<<<<<<< HEAD
          onTap: () {
            _navigateToProfile();
          },
=======
          onTap: _navigateToProfile,
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
        ),
      ],
    );
  }

<<<<<<< HEAD
  // Individual Menu Card
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
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
<<<<<<< HEAD
            Icon(
              icon,
              size: 48,
              color: const Color(0xFF1976D2),
            ),
=======
            Icon(icon, size: 48, color: const Color(0xFF1976D2)),
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
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

<<<<<<< HEAD
  // Recent Activities List - Using Consumer for dynamic updates from Provider
  Widget _buildRecentActivitiesWithConsumer() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        // Get recent activities from provider (combines invoices & payments)
        final activities = provider.getRecentActivities(limit: 10);
        
        // If no activities, show empty state
=======
  Widget _buildRecentActivitiesWithConsumer() {
    return Consumer<AppProvider>(
      builder: (context, provider, child) {
        final activities = provider.getRecentActivities(limit: 10);

>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
        if (activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.white.withOpacity(0.3),
                ),
=======
                Icon(Icons.inbox_outlined,
                    size: 64, color: Colors.white.withOpacity(0.3)),
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
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
<<<<<<< HEAD
        
        // Show activities list
=======

>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
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

<<<<<<< HEAD
  // Build activity item from provider data
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
  Widget _buildActivityItemFromProvider(Map<String, dynamic> activity) {
    final type = activity['type'] as String;
    final description = activity['description'] as String;
    final date = activity['date'] as String;
<<<<<<< HEAD
    
    // Different colors/icons based on activity type
=======

>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
    Color accentColor;
    IconData icon;
    String title;

    if (type == 'invoice') {
<<<<<<< HEAD
      final invoiceData = activity['data'];
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
      accentColor = const Color(0xFF64B5F6);
      icon = Icons.receipt_long;
      title = 'Invoice $description';
    } else if (type == 'payment') {
<<<<<<< HEAD
      final paymentData = activity['data'];
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
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
<<<<<<< HEAD
          // Icon indicator
=======
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
<<<<<<< HEAD
            child: Icon(
              icon,
              color: accentColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          // Title and date
=======
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 12),
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< HEAD
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(date),
                  style: const TextStyle(
                    color: Color(0xFF90CAF9),
                    fontSize: 12,
                  ),
                ),
=======
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(_formatDate(date),
                    style: const TextStyle(
                        color: Color(0xFF90CAF9), fontSize: 12)),
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
              ],
            ),
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  // Format date string
  String _formatDate(String date) {
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
=======
  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
      return date;
    }
  }

<<<<<<< HEAD
  // Navigate to Invoices (example)
  void _navigateToInvoices() {
    // Get provider to show invoices count
    final provider = Provider.of<AppProvider>(context, listen: false);
    final invoiceCount = provider.invoices.length;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF263A5F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'My Invoices',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'You have $invoiceCount invoice(s)\n\nInvoices page will be available soon!',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Navigate to Profile (example with provider data)
  void _navigateToProfile() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final user = provider.currentUser;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF263A5F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            user != null 
              ? 'Welcome, ${user.nickname}!\nEmail: ${user.email}\n\nProfile page coming soon!'
              : 'Please login first',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Helper method to show "Coming Soon" dialog
  void _showComingSoon(BuildContext context, String feature) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF263A5F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Coming Soon',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '$feature feature will be available soon!',
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
=======
  void _navigateToInvoices() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final invoiceCount = provider.invoices.length;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF263A5F),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('My Invoices',
            style: TextStyle(color: Colors.white)),
        content: Text(
          'You have $invoiceCount invoice(s)\n\nInvoices page will be available soon!',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK',
                style: TextStyle(color: Color(0xFF64B5F6))),
          ),
        ],
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.pushNamed(context, '/create-profile');
  }
}
>>>>>>> ec7c98875655bcd1004b94bbc46624226ad06d18
