import 'package:flutter/material.dart';
import 'package:flutter_mvvm_sqlite_app/constant/color.dart';
import 'package:flutter_mvvm_sqlite_app/views/general_content.dart';
import 'package:flutter_mvvm_sqlite_app/views/item_form.dart';
import 'package:flutter_mvvm_sqlite_app/views/quotation_app_bar.dart';
import 'package:flutter_mvvm_sqlite_app/views/quotation_header.dart';

class QuotationView extends StatefulWidget {
  const QuotationView({super.key});

  @override
  State<QuotationView> createState() => _QuotationViewState();
}

class _QuotationViewState extends State<QuotationView> {
  final ValueNotifier<bool> isGeneralView = ValueNotifier<bool>(true);
  final List<Map<String, String>> items = [];

  @override
  void dispose() {
    isGeneralView.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const QuotationAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const QuotationHeader(),
            const SizedBox(height: 16),
            _buildToggleButtons(),
            const SizedBox(height: 16),
            ValueListenableBuilder<bool>(
              valueListenable: isGeneralView,
              builder: (context, isGeneral, child) {
                return isGeneral ? GeneralContent() : const ItemForm();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButtons() {
    return ValueListenableBuilder<bool>(
      valueListenable: isGeneralView,
      builder: (context, isGeneral, child) {
        return ToggleButtons(
          isSelected: [isGeneral, !isGeneral],
          onPressed: (int index) {
            isGeneralView.value = (index == 0);
          },
          borderColor: kPrimaryColor,
          borderRadius: BorderRadius.circular(4),
          borderWidth: 2.5,
          selectedColor: Colors.white,
          selectedBorderColor: kPrimaryColor,
          fillColor: kPrimaryColor,
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width / 2 - 20,
            minHeight: 40,
          ),
          children: const [
            Center(child: Text('General', textAlign: TextAlign.center)),
            Center(child: Text('Items', textAlign: TextAlign.center)),
          ],
        );
      },
    );
  }
}
