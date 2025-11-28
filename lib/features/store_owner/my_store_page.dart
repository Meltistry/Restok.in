// lib/features/store_owner/my_store_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/store_provider.dart';
import '../../state/auth_provider.dart';
import 'create_store_page.dart';
import 'edit_store_page.dart';

class MyStorePage extends StatefulWidget {
  const MyStorePage({super.key});

  @override
  State<MyStorePage> createState() => _MyStorePageState();
}

class _MyStorePageState extends State<MyStorePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStores();
    });
  }

  void _loadStores() {
    // final authProvider = context.read<AuthProvider>();
    final userId = 1;
    // authProvider.currentUser?.idUser;

    if (userId != null) {
      context.read<StoreProvider>().loadUserStores(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A3A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB8E6E6)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Store',
          style: TextStyle(
            color: Color(0xFFB8E6E6),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<StoreProvider>(
        builder: (context, storeProvider, child) {
          if (storeProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFB8E6E6)),
            );
          }

          if (storeProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${storeProvider.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadStores,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This is where you set up your store\nfor the restockers to see',
                  style: TextStyle(color: Color(0xFFB8E6E6), fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Store List
                Expanded(
                  child: storeProvider.stores.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          itemCount: storeProvider.stores.length,
                          itemBuilder: (context, index) {
                            final store = storeProvider.stores[index];
                            return _buildStoreCard(store);
                          },
                        ),
                ),

                const Divider(color: Color(0xFF1E3A5F), height: 32),

                // Add Store Button
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateStorePage(),
                        ),
                      );

                      if (result == true) {
                        _loadStores();
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline, size: 28),
                    label: const Text(
                      'Add Store',
                      style: TextStyle(fontSize: 18),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFFB8E6E6),
                      side: const BorderSide(
                        color: Color(0xFFB8E6E6),
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: 80,
            color: Color(0xFFB8E6E6).withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No stores yet',
            style: TextStyle(
              color: Color(0xFFB8E6E6).withOpacity(0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Add Store" to create your first store',
            style: TextStyle(
              color: Color(0xFFB8E6E6).withOpacity(0.4),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreCard(store) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFB8E6E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: const Color(0xFF0A1A3A),
          backgroundImage: store.storeEpic != null
              ? NetworkImage(store.storeEpic!)
              : null,
          child: store.storeEpic == null
              ? const Icon(Icons.store, color: Color(0xFFB8E6E6))
              : null,
        ),
        title: Text(
          store.storeName,
          style: const TextStyle(
            color: Color(0xFF0A1A3A),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Color(0xFF0A1A3A)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                store.storeAddress,
                style: const TextStyle(color: Color(0xFF0A1A3A), fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFF0A1A3A)),
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditStorePage(store: store),
            ),
          );

          if (result == true) {
            _loadStores();
          }
        },
      ),
    );
  }
}
