// lib/features/store_owner/my_store_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restokin/features/store_owner/add_store_items_page.dart';
import '../../state/store_provider.dart';
import 'create_store_page.dart';
import '../home/home_page.dart';

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
  //final loadstore
  // void _loadStores() {
  //   final authProvider = context.read<AuthProvider>();
  //   final String? userIdString =
  //       authProvider.user?.id; // String ID dari Supabase User

  //   if (userIdString == null) {
  //     // BARU: Tampilkan notifikasi jika User ID NULL (User Belum Login)
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Anda belum login. Gagal memuat toko.'),
  //         backgroundColor: Color.fromARGB(255, 230, 100, 100),
  //       ),
  //     );
  //     return; // Penting: Hentikan eksekusi jika ID null
  //   }

  //   // Konversi String menjadi int (Sesuai dengan StoreProvider Anda)
  //   final int? userIdInt = int.tryParse(userIdString);

  //   if (userIdInt != null) {
  //     context.read<StoreProvider>().loadUserStores(userIdInt);
  //   } else {
  //     // BARU: Tampilkan notifikasi jika konversi gagal
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Error: ID pengguna tidak valid (bukan integer).'),
  //         backgroundColor: Color.fromARGB(255, 230, 100, 100),
  //       ),
  //     );
  //     print("Error: User ID is not a valid integer.");
  //   }
  // }

  // lib/features/store_owner/my_store_page.dart (Fungsi _loadStores)

  void _loadStores() async {
    // Get current authenticated user
    final authUser = Supabase.instance.client.auth.currentUser;
    if (authUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Not authenticated'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Get id_user from public.users table using email
    final userResponse = await Supabase.instance.client
        .from('users')
        .select('id_user')
        .eq('email', authUser.email!)
        .maybeSingle();

    if (!mounted) return;

    if (userResponse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User not found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final userId = userResponse['id_user'] as int;

    // Load stores for this user
    context.read<StoreProvider>().loadUserStores(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1A3A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1A3A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFB8E6E6)),
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/home',
              (route) => false,
            );
          },
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
            color: Color(0xFFB8E6E6).withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No stores yet',
            style: TextStyle(
              color: Color(0xFFB8E6E6).withValues(alpha: 0.6),
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap "Add Store" to create your first store',
            style: TextStyle(
              color: Color(0xFFB8E6E6).withValues(alpha: 0.4),
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
              builder: (context) => AddStoreItemsPage(store: store),
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
