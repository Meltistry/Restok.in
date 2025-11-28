import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              // Header with profile picture and greeting
              Row(
                children: [
                  // Profile Picture
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      image: const DecorationImage(
                        image: NetworkImage('https://via.placeholder.com/60'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Greeting Text
                  const Text(
                    'Hi, Carlos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              // Grid Menu (2x2)
              Expanded(
                flex: 0,
                child: GridView.count(
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
                        // Navigate to Browse Store
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.description_outlined,
                      label: 'My\nInvoices',
                      onTap: () {
                        // Navigate to My Invoices
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.store_outlined,
                      label: 'My\nStore',
                      onTap: () {
                        // Navigate to My Store
                      },
                    ),
                    _buildMenuCard(
                      icon: Icons.person_outline,
                      label: 'Profile',
                      onTap: () {
                        // Navigate to Profile
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Recent Activities Section
              const Text(
                'Recent Activities',
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Activities List
              Expanded(
                child: ListView(
                  children: [
                    _buildActivityItem(
                      title: 'Created Invoice #RS001 to Nara Store',
                      date: '12/23 2/25/2025',
                    ),
                    const SizedBox(height: 8),
                    _buildActivityItem(
                      title: 'Received Invoice #IN0001 From Alwin to B Store',
                      date: '11/09 10/26/2025',
                    ),
                    const SizedBox(height: 8),
                    _buildActivityItem(
                      title: 'Payment Received from Invoice #RS001',
                      date: '08/31 1/24/2025',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
            Icon(
              icon,
              size: 48,
              color: const Color(0xFF1976D2),
            ),
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

  Widget _buildActivityItem({
    required String title,
    required String date,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF263A5F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            date,
            style: const TextStyle(
              color: Color(0xFF90CAF9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}