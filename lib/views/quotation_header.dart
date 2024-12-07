import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/constant/color.dart';

class QuotationHeader extends StatelessWidget {
  const QuotationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        DropdownButton<String>(
          value: 'Auckland Offices',
          onChanged: (String? newValue) {},
          items: <String>['Auckland Offices', 'Other Office']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        Text(
          '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
          style: const TextStyle(fontSize: 16, color: kPrimaryColor),
        ),
      ],
    );
  }
}
