import 'dart:collection';
import 'dart:developer';

import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/models/Transaction/transaction.dart';
import 'package:flutter/material.dart';

/// This class must be a bridge between the UI and the database API.
class TransactionController extends ChangeNotifier {
  TransactionController();

  /// Helper variable that allow to kwon if an operation was done recently.
  /// Like an addiction or a deletion of a transaction
  bool _isRecentlyUpdated = true;
  bool _hasMonthDataReady = false;

  bool get hasMonthDataReady => _hasMonthDataReady;

  /// Json of transactions used in the history pages
  /// Must store all the year and realives month that store at least one
  /// transaction. It aslo associate each month with the number of transactions
  Map<String, Map<String, int>> _allTransactionsMovment = {};
  Map<String, Map<String, int>> get allTransactionsMovment => _allTransactionsMovment;

  /// This variabile should be filled with the transaction searched from
  /// the ``loadDataWithDate`` function.
  List<Transaction> _monthTransaction = [];
  List<Transaction> get monthTransaction {
    return UnmodifiableListView(_monthTransaction.toList()..sort((Transaction t1, Transaction t2) => t1.date!.compareTo(t2.date!)));
  }

  /// Load the _allTransactionsMovment from the database
  /// will update based on the value of a boolean variable. If no operation are
  /// done recently will not request an update
  Future<void> loadData() async {
    if (_isRecentlyUpdated == false) {
      log("Data reload request but no update was done recently. Request denied");
    }

    _allTransactionsMovment = await locator<DatabaseBridge>().getTransactionsGroupedByYearAndMonth();
    _isRecentlyUpdated = false;
  }

  /// Given a date it will return all the transactions for that month and that
  /// year from the database. Will update ``_hasMonthDataReady`` when ready
  Future<void> loadDataWithDate(DateTime date) async {
    _hasMonthDataReady = false;
    notifyListeners();

    _monthTransaction = locator<DatabaseBridge>().getTransitionsForThisMonth(date: date);

    _hasMonthDataReady = true;
    notifyListeners();
  }

  /// Add a transaction to the database if that transaciton is new.
  /// If not the transaciton is updated
  Future<void> put(Transaction transaction) async {
    await locator<DatabaseBridge>().addTransaction(transaction);
    _hasMonthDataReady = false;
    notifyListeners();
  }

  Future<void> delete(Transaction transaction) async {
    await locator<DatabaseBridge>().removeTransaction(transaction);
    _hasMonthDataReady = false;
    notifyListeners();
  }
}
