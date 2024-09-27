import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:expense_tracker/models/TransactionType.dart';
import 'package:expense_tracker/models/Transaction/transaction.dart';
import 'package:expense_tracker/view/Components/Tag/tag_container.dart';
import 'package:expense_tracker/view/Components/Tag/tag_menu.dart';
import 'package:flutter/material.dart';

class EditTransaction extends StatefulWidget {
  final bool isNewTransaction;
  final Transaction? transaction;
  const EditTransaction({super.key, required this.isNewTransaction, this.transaction});

  @override
  State<EditTransaction> createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  late Transaction transaction;
  final _formKey = GlobalKey<FormState>();

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    );

    if (date == null) return;

    transaction.date = date;
    setState(() {});
  }

  void _showTagMenu() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TagMenu(transaction: transaction),
    );

    setState(() {});
  }

  void _deleteTransaction() async {
    final dialog = AlertDialog(
      title: const Text("Eliminazione movimento"),
      content: const Text("Sicuro di voler eliminare questo movimento?"),
      actions: [
        TextButton(
          key: const ValueKey("cancel"),
          onPressed: () => Navigator.pop(context, false),
          child: const Text("Annulla"),
        ),
        TextButton(
          key: const ValueKey("confirm"),
          onPressed: () => Navigator.pop(context, true),
          child: const Text("Conferma"),
        ),
      ],
    );

    bool? result = await showDialog<bool?>(context: context, builder: (context) => dialog);

    if (result == true) {
      await locator<TransactionController>().delete(transaction);
      //
      _quit();
    }
  }

  void _saveTransaction() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    await locator<TransactionController>().put(transaction);
    _quit();
  }

  void _quit() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isNewTransaction == false) {
      assert(widget.transaction != null, "A null transaction is passed during to edit mode");
      transaction = widget.transaction!.copy();
    } else {
      transaction = Transaction();
      transaction.type = TransactionType.income;
      transaction.name = "";
      transaction.note = "";
      transaction.price = 0;
      transaction.date = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isNewTransaction ? "New Transaction" : "Edit transacion"),
        leading: IconButton(
          key: const ValueKey("quit"),
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _quit(),
        ),
      ),
      body: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Informazioni principali", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.start),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: transaction.price.toStringAsFixed(2),
                                key: const ValueKey("price"),
                                inputFormatters: [CurrencyTextInputFormatter.currency(locale: "it", symbol: "€")],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(label: Text("Prezzo")),
                                validator: (value) => value!.isNotEmpty ? null : "Prezzo non valido",
                                onChanged: (string) {
                                  String value = string.replaceAll(RegExp(r"€"), "").trim().replaceAll(",", ".");
                                  double? price = double.tryParse(value);
                                  if (price == null) {
                                    return;
                                  } else {
                                    transaction.price = price;
                                  }
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                key: const ValueKey("date"),
                                controller: TextEditingController(text: transaction.formattedDate),
                                readOnly: true,
                                keyboardType: TextInputType.datetime,
                                validator: (value) => value!.isNotEmpty ? null : "Data non valida",
                                decoration: InputDecoration(
                                  label: const Text("Date"),
                                  suffixIcon: IconButton(
                                    onPressed: _showDatePicker,
                                    icon: const Icon(Icons.calendar_month),
                                  ),
                                ),
                                onTap: _showDatePicker,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const ValueKey("name"),
                          controller: TextEditingController(text: transaction.name),
                          decoration: const InputDecoration(
                            label: Text("Nome"),
                          ),
                          validator: (value) => value!.isNotEmpty ? null : "Il nome non può essere vuoto",
                          onChanged: (value) => transaction.name = value,
                        ),
                        const SizedBox(height: 16),
                        SegmentedButton(
                          key: const ValueKey("transaction_type"),
                          onSelectionChanged: (Set<TransactionType> change) {
                            transaction.type = change.first;
                            setState(() {});
                          },
                          showSelectedIcon: false,
                          segments: const [
                            ButtonSegment(
                              value: TransactionType.income,
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add),
                                  SizedBox(width: 8),
                                  Text("Entrata"),
                                ],
                              ),
                            ),
                            ButtonSegment(
                              value: TransactionType.expense,
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.money),
                                  SizedBox(width: 8),
                                  Text("Uscita"),
                                ],
                              ),
                            ),
                          ],
                          selected: {transaction.type},
                        ),
                      ],
                    ),
                  ),
                ),

                //////////////////////////////////////////////////////////////////

                Card(
                  margin: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Informzioni aggiuntive", style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.start),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Tags", style: Theme.of(context).textTheme.bodyLarge),
                                IconButton(
                                  key: const ValueKey("add_tag"),
                                  onPressed: _showTagMenu,
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                            TagContainer(tags: transaction.getAllTags()),
                          ],
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          key: const ValueKey("description"),
                          controller: TextEditingController(text: transaction.note),
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            label: Text("Descrizione"),
                            alignLabelWithHint: true,
                          ),
                          minLines: 3,
                          maxLines: null,
                          onChanged: (value) => transaction.note = value,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // if (widget.isNewTransaction == false)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.isNewTransaction == false)
                  FilledButton.icon(
                    key: const ValueKey("delete"),
                    onPressed: _deleteTransaction,
                    label: const Text("Elimina"),
                    icon: const Icon(Icons.delete),
                  ),
                FilledButton.icon(
                  key: const ValueKey("save"),
                  onPressed: _saveTransaction,
                  label: const Text("Salva"),
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
