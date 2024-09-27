import 'package:expense_tracker/view/Components/menu/value_list_item.dart';
import 'package:flutter/material.dart';

class ValueList extends StatelessWidget {
  final List<ValueListItem> children;
  final String? title;
  const ValueList({super.key, this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            title == null ? Container() : Text(title!, style: Theme.of(context).textTheme.headlineSmall),
            title == null ? Container() : const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
