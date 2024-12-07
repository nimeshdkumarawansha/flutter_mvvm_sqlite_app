import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/constant/color.dart';

class GeneralContent extends StatelessWidget {
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();
  final TextEditingController discountController = TextEditingController();

  GeneralContent({super.key});

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
          child: const Text(
            'Net Amount: 1,900',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(labelText: 'Item'),
        ),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(labelText: 'Reason'),
        ),
        const SizedBox(height: 8),
        const TextField(
          decoration: InputDecoration(labelText: 'Price'),
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
              onPressed: () {},
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
        // Responsive DataTable
        LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 20.0,
                  columns: [
                    const DataColumn(
                        label: Text('Item',
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(
                      label: Container(
                        alignment:
                            Alignment.centerRight, // Aligns text to the right
                        child: const Text(
                          'Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                        label: Container(
                      alignment: Alignment.centerRight,
                      child: const Text('Qty',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    DataColumn(
                        label: Container(
                      alignment: Alignment.centerRight,
                      child: const Text('Discount',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                    DataColumn(
                        label: Container(
                      alignment: Alignment.centerRight,
                      child: const Text('Total',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )),
                  ],
                  rows: const [
                    DataRow(cells: [
                      DataCell(Text('Item 1')),
                      DataCell(Text('1,000')),
                      DataCell(Text('2')),
                      DataCell(Text('100')),
                      DataCell(Text('1,900')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Test 2')),
                      DataCell(Text('1,000')),
                      DataCell(Text('2')),
                      DataCell(Text('100')),
                      DataCell(Text('1,900')),
                    ]),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}