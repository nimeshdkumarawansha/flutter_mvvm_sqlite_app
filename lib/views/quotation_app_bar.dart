import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/constant/color.dart';

class QuotationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSave; // Accepts a callback for the save functionality

  const QuotationAppBar({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const Icon(Icons.receipt_long, color: Colors.white),
      title: const Text('Quotation', style: TextStyle(color: Colors.white)),
      backgroundColor: kPrimaryColor,
      actions: [
        // Action for the left arrow
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.keyboard_double_arrow_left, color: Colors.white),
        ),
        // Action for the check icon
        IconButton(
          onPressed: onSave, // Call the passed save function when clicked
          icon: const Icon(Icons.check_circle, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
