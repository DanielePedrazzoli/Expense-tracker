import 'package:expense_tracker/controller/month_helper.dart';
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:expense_tracker/view/Components/menu/value_list.dart';
import 'package:expense_tracker/view/Components/menu/value_list_item.dart';
import 'package:expense_tracker/view/pages/Transaction/inspect_transaction_month.dart';
import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  final TransactionController controller;
  const TransactionHistory({super.key, required this.controller});

  void onMonthTap(BuildContext context, String year, String month) async {
    DateTime date = DateTime(int.parse(year), MonthHelper.retriveMonthIndex(month), 1);
    controller.loadDataWithDate(date);
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InspectTransactionMonth(
          date: date,
          year: year,
          controller: controller,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cronologia movimenti"),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          var data = controller.allTransactionsMovment;

          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 64),
            itemBuilder: (context, index) {
              var year = data.keys.elementAt(index);
              return ValueList(
                title: data.keys.elementAt(index),
                children: data[year]!.keys.map(
                  (month) {
                    var numberOfTransaction = data[year]![month];
                    return ValueListItem(
                      title: month,
                      value: Text(numberOfTransaction.toString()),
                      padding: 12,
                      onTap: () => onMonthTap(context, year, month),
                    );
                  },
                ).toList(),
              );
            },
            itemCount: data.keys.length,
          );
        },
      ),
    );
  }
}
