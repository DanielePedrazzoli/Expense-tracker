import 'package:expense_tracker/models/Transaction/transaction.dart';
import 'package:expense_tracker/models/TransactionType.dart';
import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final Function() onTap;
  const TransactionCard({super.key, required this.transaction, required this.onTap});

  TextStyle? _getTrailingStyle(BuildContext context) {
    bool isIcome = transaction.type == TransactionType.income;
    Color textColor = isIcome ? const Color.fromARGB(255, 27, 204, 0) : const Color.fromARGB(255, 201, 52, 18);

    return Theme.of(context).textTheme.bodyMedium?.copyWith(color: textColor);
  }

  TextStyle? _getTitleStyle(BuildContext context) {
    bool isEmpty = transaction.name.isEmpty;

    var fontStyle = isEmpty ? FontStyle.italic : FontStyle.normal;

    return Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: fontStyle);
  }

  String _formatText() {
    bool isIcome = transaction.type == TransactionType.income;
    return "${isIcome ? "+" : "-"}${transaction.price.toStringAsFixed(2)} €";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(
            transaction.name.isEmpty ? "Nessun nome fornito" : transaction.name,
            style: _getTitleStyle(context),
          ),
          subtitle: Text(transaction.formattedDate!),
          trailing: Text(_formatText(), style: _getTrailingStyle(context)),
        ),
      ),
    );
  }
}
