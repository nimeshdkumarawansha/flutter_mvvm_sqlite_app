import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/views/quotation.dart';

void main() => runApp(const QuotationApp());

class QuotationApp extends StatelessWidget {
  const QuotationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: QuotationView(),
    );
  }
}

