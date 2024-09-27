import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final TransactionController controller;
  const Home({super.key, required this.controller});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String getBalance() {
    var balance = locator<DatabaseBridge>().getBalnceForThisMonth();

    return balance.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getBalance(),
                key: const ValueKey("month_balance"),
              ),
              const SizedBox(height: 128),
              const Text("Balnce for this month"),
            ],
          ),
        );
      },
    );
  }
}
