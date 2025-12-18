import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/store_model.dart';
import '../../data/models/item_model.dart';
import '../../data/services/store_service.dart';
import '../restock/restock_proof_page.dart'; // Navigasi ke Proof Page

class StoreDetailRestockPage extends StatefulWidget {
  final StoreModel store;
  const StoreDetailRestockPage({super.key, required this.store});

  @override
  State<StoreDetailRestockPage> createState() => _StoreDetailRestockPageState();
}

class _StoreDetailRestockPageState extends State<StoreDetailRestockPage> {
  final StoreService _storeService = StoreService();
  late Future<List<ItemModel>> _futureItems;
  final Map<ItemModel, int> _cart = {};

  @override
  void initState() {
    super.initState();
    _futureItems = _storeService.getItemsByStore(widget.store.idStore ?? 0);
  }

  void _updateQty(ItemModel item, int delta) {
    setState(() {
      final currentQty = _cart[item] ?? 0;
      final newQty = currentQty + delta;
      if (newQty > 0) {
        _cart[item] = newQty;
      } else {
        _cart.remove(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Color(0xFF1a2847), Color(0xFF0d1829)],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const CircleAvatar(radius: 20, backgroundColor: Colors.white, child: Icon(Icons.store, color: Color(0xFF1a7a8a))),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.store.storeName, style: const TextStyle(color: Color(0xFF5dd9e8), fontSize: 20, fontWeight: FontWeight.bold)),
                        Text(widget.store.storeAddress, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                ),
                child: FutureBuilder<List<ItemModel>>(
                  future: _futureItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                    if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("No items available"));

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 25, 20, 100),
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        final qty = _cart[item] ?? 0;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1a2847))),
                                  Text(currencyFormat.format(item.itemPrice), style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                // Badge simulasi stock alert (hardcoded seperti desain)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  margin: const EdgeInsets.only(right: 10),
                                  decoration: BoxDecoration(color: const Color(0xFFffe6e6), borderRadius: BorderRadius.circular(8)),
                                  child: const Text("-", style: TextStyle(color: Color(0xFFd32f2f), fontWeight: FontWeight.bold)),
                                ),
                                IconButton(icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF1a7a8a)), onPressed: () => _updateQty(item, -1)),
                                SizedBox(width: 30, child: Text('$qty', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                                IconButton(icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1a7a8a)), onPressed: () => _updateQty(item, 1)),
                              ],
                            )
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _cart.isNotEmpty ? Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: FloatingActionButton.extended(
          backgroundColor: const Color(0xFF1a7a8a),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => RestockProofPage(cart: _cart, store: widget.store),
            ));
          },
          label: Text('Restock (${_cart.length} items)', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
