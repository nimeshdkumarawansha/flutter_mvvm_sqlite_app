import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/constant/color.dart';

class QuotationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const QuotationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.receipt_long, color: Colors.white),
      title: const Text('Quotation', style: TextStyle(color: Colors.white)),
      backgroundColor: kPrimaryColor,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_double_arrow_left,
              color: Colors.white),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
