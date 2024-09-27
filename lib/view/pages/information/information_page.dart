import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/view/Components/menu/value_list.dart';
import 'package:expense_tracker/view/Components/menu/value_list_item.dart';
import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bridge = locator<DatabaseBridge>();
    int transactionsCount = bridge.getTransactionsCount();
    int tagsCount = bridge.getTagsCount();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Informazioni"),
      ),
      body: ListView(
        children: [
          const ValueList(
            title: "Applicazione",
            children: [
              ValueListItem(title: "Versione", value: Text("1.0.0")),
              ValueListItem(title: "Sviluppatore", value: Text("Pedrazzoli Daniele")),
            ],
          ),
          ValueList(
            title: "Database",
            children: [
              ValueListItem(title: "Numero di transazioni salvate", value: Text(transactionsCount.toString())),
              ValueListItem(title: "Numero di tag presenti", value: Text(tagsCount.toString())),
            ],
          ),
        ],
      ),
    );
  }
}
