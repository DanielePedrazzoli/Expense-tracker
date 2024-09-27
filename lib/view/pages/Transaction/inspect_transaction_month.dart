import 'package:expense_tracker/controller/month_helper.dart';
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:expense_tracker/models/Transaction/transaction.dart';
import 'package:expense_tracker/models/TransactionType.dart';
import 'package:expense_tracker/models/char/chart_data.dart';
import 'package:expense_tracker/models/char/chart_option.dart';
import 'package:expense_tracker/view/Components/chart/inspect_month_chart.dart';
import 'package:expense_tracker/view/Components/transaction/transaction_card.dart';
import 'package:expense_tracker/view/pages/Transaction/chart_page.dart';
import 'package:expense_tracker/view/pages/Transaction/edit_transaction.dart';
import 'package:flutter/material.dart';

class InspectTransactionMonth extends StatefulWidget {
  final String year;
  final TransactionController controller;
  final DateTime date;
  const InspectTransactionMonth({super.key, required this.year, required this.controller, required this.date});

  @override
  State<InspectTransactionMonth> createState() => _InspectTransactionMonthState();
}

class _InspectTransactionMonthState extends State<InspectTransactionMonth> {
  ChartOption chartOption = ChartOption();

  double _totalIncome = 0;
  double _totaleExpense = 0;

  /// A ``ChartData`` object will be created for each day. All the
  /// income and the expenses in that dey will be summed up
  ///
  /// At the end i must have a number of ChartData equal to the numbe of day in
  /// the corrisponding month
  List<ChartData> _generateCharData(List<Transaction> transactions) {
    List<ChartData> data = [];
    int dayInMonth = MonthHelper.returnMonthLenght(widget.date.month);
    for (int day = 1; day <= dayInMonth + 1; day++) {
      var transactionsOfDay = transactions.where((Transaction t) => t.date!.day == day);

      double income = 0;
      double expense = 0;
      _totalIncome = 0;
      _totaleExpense = 0;
      for (Transaction t in transactionsOfDay) {
        if (t.type == TransactionType.income) {
          income += t.price;
          _totalIncome += t.price;
        } else {
          expense += t.price;
          _totaleExpense += t.price;
        }
      }

      data.add(ChartData(day, income, expense));
    }

    return data;
  }

  @override
  void initState() {
    super.initState();
    int dayInMonth = MonthHelper.returnMonthLenght(widget.date.month + 1);
    chartOption.monthLenght = dayInMonth;
    initData();
  }

  void initData() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${MonthHelper.getMonthName(widget.date.month)} ${widget.year}"),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, child) {
          // widget displayed when the data are requeste but not ready yet
          if (widget.controller.hasMonthDataReady == false) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Transaction> data = widget.controller.monthTransaction;
          TextStyle? style = Theme.of(context).textTheme.bodyMedium;

          // Widget displayed when data are avaiable
          return ListView(
            children: [
              InspectMonthChart(
                data: _generateCharData(data),
                option: chartOption,
              ),
              // const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    FilterChip(
                      side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                      selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      selected: chartOption.showCandlerChart,
                      onSelected: (value) {
                        setState(() {
                          chartOption.showCandlerChart = value;
                        });
                      },
                      label: const Text("Movimenti"),
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      side: BorderSide(color: Theme.of(context).colorScheme.secondary),
                      selectedColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      selected: chartOption.showLineChart,
                      onSelected: (value) {
                        setState(() {
                          chartOption.showLineChart = value;
                        });
                      },
                      label: const Text("Andamento"),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      icon: const Icon(Icons.expand),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChartPage(
                              data: _generateCharData(data),
                              option: chartOption,
                            ),
                          ),
                        );
                      },
                      label: const Text("Espandi"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Numero totale di transazioni", style: style),
                            Text(data.length.toString(), style: style),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Guadagno totale del mese", style: style),
                            Text(_totalIncome.toStringAsFixed(2), style: style),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Spese totali del mese", style: style),
                            Text(_totalIncome.toStringAsFixed(2), style: style),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Risultato complessivo", style: style),
                            Text((_totalIncome - _totaleExpense).toStringAsFixed(2), style: style),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: data
                      .map(
                        (element) => TransactionCard(
                          transaction: element,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditTransaction(
                                  isNewTransaction: false,
                                  transaction: element,
                                ),
                              ),
                            );
                            await widget.controller.loadDataWithDate(widget.date);
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
