import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/firestore_service.dart';

class AddEditItemScreen extends StatefulWidget {
  final Item? item;

  const AddEditItemScreen({Key? key, this.item}) : super(key: key);

  @override
  _AddEditItemScreenState createState() => _AddEditItemScreenState();
}

class _AddEditItemScreenState extends State<AddEditItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _categoryCtrl = TextEditingController();

  final FirestoreService _service = FirestoreService();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final it = widget.item;
    if (it != null) {
      _nameCtrl.text = it.name;
      _quantityCtrl.text = it.quantity.toString();
      _priceCtrl.text = it.price.toStringAsFixed(2);
      _categoryCtrl.text = it.category;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quantityCtrl.dispose();
    _priceCtrl.dispose();
    _categoryCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final name = _nameCtrl.text.trim();
    final quantity = int.tryParse(_quantityCtrl.text.trim()) ?? 0;
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0.0;
    final category = _categoryCtrl.text.trim();

    final now = DateTime.now();

    try {
      if (widget.item == null) {
        final item = Item(
          name: name,
          quantity: quantity,
          price: price,
          category: category,
          createdAt: now,
        );
        await _service.addItem(item);
      } else {
        final item = Item(
          id: widget.item!.id,
          name: name,
          quantity: quantity,
          price: price,
          category: category,
          createdAt: widget.item!.createdAt,
        );
        await _service.updateItem(item);
      }

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final id = widget.item?.id;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Delete item?'),
        content: const Text('This will permanently delete the item.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(c).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(c).pop(true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;

    await _service.deleteItem(id);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Item' : 'Add Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _quantityCtrl,
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter quantity' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter price' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryCtrl,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saving ? null : _save,
                        child: _saving ? const CircularProgressIndicator() : const Text('Save'),
                      ),
                    ),
                    if (isEdit) ...[
                      const SizedBox(width: 12),
                      OutlinedButton(
                        onPressed: _delete,
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ]
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
