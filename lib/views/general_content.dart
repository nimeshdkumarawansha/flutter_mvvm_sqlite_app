import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/constant/color.dart';
import 'package:flutter_mvvm_sqlite_app/services/database_helper.dart';

class GeneralContent extends StatefulWidget {
  const GeneralContent({super.key});

  @override
  State<GeneralContent> createState() => _GeneralContentState();
}

class _GeneralContentState extends State<GeneralContent> {
  final TextEditingController itemController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController discountController = TextEditingController();
  final List<Map<String, dynamic>> tableData = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  double netAmount = 0;

  List<Map<String, dynamic>> suggestions = [];

  void _searchItems(String query) async {
    FocusScope.of(context).unfocus();
    if (query.isNotEmpty) {
      final results = await dbHelper.searchItems(query);
      setState(() {
        suggestions = results;
      });
    } else {
      setState(() {
        suggestions.clear();
      });
    }
  }

  void _selectItem(Map<String, dynamic> item) {
    setState(() {
      itemController.text = item['name'];
      priceController.text = item['price'].toString();

      // Ensure suggestions is a mutable list
      suggestions = List.from(suggestions);
      suggestions.clear();
    });
  }

  void _addToTable() {
    final String itemName = itemController.text;
    final double price = double.tryParse(priceController.text) ?? 0;
    final int quantity = int.tryParse(quantityController.text) ?? 1;
    final double discount = double.tryParse(discountController.text) ?? 0;

    if (itemName.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid item details')),
      );
      return;
    }

    final double total = (price * quantity) * (100 - discount) / 100;

    setState(() {
      tableData.add({
        'item_name': itemName,
        'price': price,
        'quantity': quantity,
        'discount': discount,
        'total': total,
      });
      netAmount += total;
      itemController.clear();
      priceController.clear();
      quantityController.clear();
      discountController.clear();
    });
  }

  void _saveData() async {
    if (tableData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to save')),
      );
      return;
    }

    await dbHelper.saveQuotations(tableData);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data saved successfully!')),
    );

    setState(() {
      tableData.clear();
      netAmount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            'Net Amount: $netAmount',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: itemController,
          keyboardType: TextInputType.number,
          onChanged: _searchItems,
          decoration: const InputDecoration(labelText: 'Item'),
        ),
        if (suggestions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              itemCount: suggestions.length,
              itemBuilder: (context, index) {
                final item = suggestions[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('Price: ${item['price']}'),
                  onTap: () => _selectItem(item),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Price'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Qty'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Discount %'),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _addToTable,
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('ADD', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 20.0,
                  columns: const [
                    DataColumn(
                        label: Text('Item',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Price',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Qty',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Discount',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                        label: Text('Total',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: tableData
                      .map(
                        (row) => DataRow(cells: [
                          DataCell(Text(row['item_name'])),
                          DataCell(Text(row['price'].toString())),
                          DataCell(Text(row['quantity'].toString())),
                          DataCell(Text('${row['discount']}%')),
                          DataCell(Text(row['total'].toStringAsFixed(2))),
                        ]),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
          ),
          child: const Text('SAVE', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
