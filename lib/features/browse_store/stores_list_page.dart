import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/store_model.dart';
import '../../data/services/store_service.dart';
import 'store_detail_restock_page.dart';

class StoresListPage extends StatefulWidget {
  const StoresListPage({super.key});

  @override
  State<StoresListPage> createState() => _StoresListPageState();
}

class _StoresListPageState extends State<StoresListPage> {
  final StoreService _storeService = StoreService();
  late Future<List<StoreModel>> _futureStores;
  final TextEditingController _searchController = TextEditingController();
  List<StoreModel> _allStores = [];
  List<StoreModel> _filteredStores = [];

  @override
  void initState() {
    super.initState();
    _futureStores = _storeService.getStores();
    _loadStores();
  }

  Future<void> _loadStores() async {
    try {
      final stores = await _storeService.getStores();
      setState(() {
        _allStores = stores;
        _filteredStores = stores;
      });
    } catch (e) {
      // Handle error
    }
  }

  void _filterStores(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredStores = _allStores;
      } else {
        _filteredStores = _allStores.where((store) {
          final storeName = store.storeName.toLowerCase();
          final storeAddress = store.storeAddress.toLowerCase();
          final searchLower = query.toLowerCase();
          return storeName.contains(searchLower) ||
              storeAddress.contains(searchLower);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111749),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Color(0xFF5dd9e8),
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Info Banner
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF5dd9e8).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white),
                  ),
                  child: const Text(
                    'i',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stores',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Find stores that needs their items restocked',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Title Section
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Stores',
                  style: TextStyle(
                    color: Color(0xFF5dd9e8),
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Find stores that needs their items\nrestocked',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _filterStores,
                decoration: InputDecoration(
                  hintText: 'Look for a store',
                  hintStyle: const TextStyle(
                    color: Color(0xFF5dd9e8),
                    fontSize: 16,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF5dd9e8),
                    size: 24,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: const TextStyle(color: Color(0xFF1a2847), fontSize: 16),
              ),
            ),
          ),

          // Store List
          Expanded(
            child: _filteredStores.isEmpty && _searchController.text.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.white.withOpacity(0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No stores found',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : FutureBuilder<List<StoreModel>>(
                    future: _futureStores,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting &&
                          _allStores.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF5dd9e8),
                          ),
                        );
                      } else if (snapshot.hasError && _allStores.isEmpty) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else if (_filteredStores.isEmpty &&
                          _allStores.isEmpty) {
                        return const Center(
                          child: Text(
                            'No stores found.',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _filteredStores.length,
                        itemBuilder: (context, index) {
                          final store = _filteredStores[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      StoreDetailRestockPage(store: store),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFc5f5f8),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child:
                                        store.storeEpic != null &&
                                            store.storeEpic!.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: store.storeEpic!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Container(
                                                      color: Colors.white,
                                                      child: const Icon(
                                                        Icons.store,
                                                        color: Color(
                                                          0xFF1a7a8a,
                                                        ),
                                                        size: 30,
                                                      ),
                                                    ),
                                          )
                                        : Container(
                                            color: Colors.white,
                                            child: const Icon(
                                              Icons.store,
                                              color: Color(0xFF1a7a8a),
                                              size: 30,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          store.storeName,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1a7a8a),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 14,
                                              color: Color(0xFF1a7a8a),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                store.storeAddress,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF1a7a8a),
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xFF1a7a8a),
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
