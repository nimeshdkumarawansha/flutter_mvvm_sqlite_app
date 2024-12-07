import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/constant/color.dart';
import 'package:flutter_mvvm_sqlite_app/services/database_helper.dart';

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  State<ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<ItemForm> {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final List<Map<String, String>> items = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final fetchedItems = await dbHelper.fetchItems();
    setState(() {
      items.clear();
      items.addAll(
        fetchedItems.map((item) => {
              'name': item['name'].toString(),
              'price': item['price'].toString(),
            }),
      );
    });
  }

  Future<void> _addItem() async {
    final name = itemNameController.text.trim();
    final priceText = itemPriceController.text.trim();

    if (name.isEmpty || priceText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid number for price.')),
      );
      return;
    }

    await dbHelper.insertItem(name, price);
    itemNameController.clear();
    itemPriceController.clear();
    await _loadItems();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item added successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: itemNameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(labelText: 'Item Name'),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: itemPriceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Price'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _addItem,
          style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              )),
          child: const Text('ADD', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 16),
        DataTable(
          columns: const [
            DataColumn(label: Text('Item Name')),
            DataColumn(label: Text('Price')),
          ],
          rows: items
              .map(
                (item) => DataRow(
                  cells: [
                    DataCell(Text(item['name']!)),
                    DataCell(Text(item['price']!)),
                  ],
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
