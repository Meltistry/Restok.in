// lib/features/store_owner/add_store_items_page.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../data/models/store_model.dart';
import '../../state/store_provider.dart';
import 'edit_store_page.dart';

class AddStoreItemsPage extends StatefulWidget {
  final StoreModel store;

  const AddStoreItemsPage({super.key, required this.store});

  @override
  State<AddStoreItemsPage> createState() => _AddStoreItemsPageState();
}

class _AddStoreItemsPageState extends State<AddStoreItemsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoreProvider>().loadStoreItems(widget.store.idStore!);
    });
  }

  void _showAddItemDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddItemDialog(storeId: widget.store.idStore!),
    );
  }

  void _showEditItemDialog(item) {
    showDialog(
      context: context,
      builder: (context) => _EditItemDialog(item: item),
    );
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Header
            Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: const Color(0xFF1E3A5F),
                  backgroundImage: widget.store.storeEpic != null
                      ? NetworkImage(widget.store.storeEpic!)
                      : null,
                  child: widget.store.storeEpic == null
                      ? const Icon(
                          Icons.store,
                          color: Color(0xFFB8E6E6),
                          size: 32,
                        )
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.store.storeName,
                        style: const TextStyle(
                          color: Color(0xFFB8E6E6),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 16,
                            color: Color(0xFF1E7B7B),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              widget.store.storeAddress,
                              style: const TextStyle(
                                color: Color(0xFF1E7B7B),
                                fontSize: 14,
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
                TextButton(
                  onPressed: () {
                    // Navigate to edit store
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EditStorePage(store: widget.store),
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF7B68A6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'edit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Items List
            Expanded(
              child: Consumer<StoreProvider>(
                builder: (context, storeProvider, child) {
                  if (storeProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFB8E6E6),
                      ),
                    );
                  }

                  if (storeProvider.currentStoreItems.isEmpty) {
                    return _buildEmptyState();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Item',
                        style: TextStyle(
                          color: Color(0xFFB8E6E6),
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: ListView.builder(
                          itemCount: storeProvider.currentStoreItems.length + 1,
                          itemBuilder: (context, index) {
                            if (index ==
                                storeProvider.currentStoreItems.length) {
                              return _buildAddButton();
                            }

                            final item = storeProvider.currentStoreItems[index];
                            return _buildItemCard(item);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Now let's add some\nitems you want to get\nrestocked!",
          style: TextStyle(
            color: Color(0xFFB8E6E6),
            fontSize: 28,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Add Item',
          style: TextStyle(color: Color(0xFFB8E6E6), fontSize: 16),
        ),
        const SizedBox(height: 12),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _showAddItemDialog,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFB8E6E6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.add_circle_outline,
            size: 48,
            color: Color(0xFF0A1A3A),
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFB8E6E6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.itemName,
                  style: const TextStyle(
                    color: Color(0xFF0A1A3A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.formattedPrice,
                  style: const TextStyle(
                    color: Color(0xFF0A1A3A),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showEditItemDialog(item),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF7B68A6),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text('Edit', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF1E7B7B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Checkbox(
              value: false,
              onChanged: (value) {},
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.all(const Color(0xFF1E7B7B)),
            ),
          ),
        ],
      ),
    );
  }
}

// Add Item Dialog
class _AddItemDialog extends StatefulWidget {
  final int storeId;

  const _AddItemDialog({required this.storeId});

  @override
  State<_AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<_AddItemDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _addItem() async {
    if (!_formKey.currentState!.validate()) return;

    final price = int.tryParse(
      _priceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (price == null) return;

    final storeProvider = context.read<StoreProvider>();
    final success = await storeProvider.addItem(
      storeId: widget.storeId,
      itemName: _nameController.text.trim(),
      itemPrice: price,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Item added successfully!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E3A5F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('Add Item', style: TextStyle(color: Color(0xFFB8E6E6))),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Color(0xFF0A1A3A)),
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: const TextStyle(color: Color(0xFF0A1A3A)),
                filled: true,
                fillColor: const Color(0xFFB8E6E6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              style: const TextStyle(color: Color(0xFF0A1A3A)),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: const TextStyle(color: Color(0xFF0A1A3A)),
                prefixText: 'Rp. ',
                prefixStyle: const TextStyle(color: Color(0xFF0A1A3A)),
                filled: true,
                fillColor: const Color(0xFFB8E6E6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter price';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFFB8E6E6)),
          ),
        ),
        ElevatedButton(
          onPressed: _addItem,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E7B7B),
          ),
          child: const Text('Add'),
        ),
      ],
    );
  }
}

// Edit Item Dialog
class _EditItemDialog extends StatefulWidget {
  final dynamic item;

  const _EditItemDialog({required this.item});

  @override
  State<_EditItemDialog> createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<_EditItemDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.itemName);
    _priceController = TextEditingController(
      text: widget.item.itemPrice.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateItem() async {
    if (!_formKey.currentState!.validate()) return;

    final price = int.tryParse(
      _priceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
    );
    if (price == null) return;

    final storeProvider = context.read<StoreProvider>();
    final success = await storeProvider.updateItem(
      itemId: widget.item.idItem,
      itemName: _nameController.text.trim(),
      itemPrice: price,
    );

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated successfully!')),
      );
    }
  }

  Future<void> _deleteItem() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final storeProvider = context.read<StoreProvider>();
    final success = await storeProvider.deleteItem(widget.item.idItem);

    if (!mounted) return;

    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E3A5F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Edit Item', style: TextStyle(color: Color(0xFFB8E6E6))),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteItem,
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Color(0xFF0A1A3A)),
              decoration: InputDecoration(
                labelText: 'Item Name',
                labelStyle: const TextStyle(color: Color(0xFF0A1A3A)),
                filled: true,
                fillColor: const Color(0xFFB8E6E6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter item name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              style: const TextStyle(color: Color(0xFF0A1A3A)),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Price',
                labelStyle: const TextStyle(color: Color(0xFF0A1A3A)),
                prefixText: 'Rp. ',
                prefixStyle: const TextStyle(color: Color(0xFF0A1A3A)),
                filled: true,
                fillColor: const Color(0xFFB8E6E6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter price';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFFB8E6E6)),
          ),
        ),
        ElevatedButton(
          onPressed: _updateItem,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1E7B7B),
          ),
          child: const Text('Update'),
        ),
      ],
    );
  }
}
