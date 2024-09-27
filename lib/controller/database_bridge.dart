import 'dart:developer';
import 'dart:io';

import 'package:expense_tracker/controller/month_helper.dart';
import 'package:expense_tracker/models/Transaction/transaction.dart';
import 'package:expense_tracker/models/TransactionType.dart';
import 'package:expense_tracker/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseBridge with ChangeNotifier {
  DatabaseBridge();

  bool _isReady = false;
  late Isar isar;
  late Directory _appSupportDirectory;

  bool get isReady => _isReady;

  String get directoryPath => _appSupportDirectory.path;

  init() async {
    _appSupportDirectory = await getApplicationSupportDirectory();
    isar = await Isar.open(
      [TransactionSchema, TagSchema],
      directory: _appSupportDirectory.path,
    );

    _isReady = true;
    notifyListeners();
  }

  Future<void> clearDatabase() async {
    if (Platform.environment.containsKey('INTEGRATION_TEST')) {
      log("Clearing database");
      await isar.writeTxn(() async {
        await isar.tags.clear();
        await isar.transactions.clear();
      });
      log("Database cleared");
    } else {
      log("Request database clear without being in test mode");
      log("Request denied");
    }
  }

  List<Tag> getAllTags() {
    return isar.tags.where().findAllSync();
  }

  Future<void> addTag(Tag t) async {
    isar.writeTxn(() async {
      isar.tags.put(t);
    });
  }

  Future<void> chnageTagCorrelation(Transaction transaction, Tag tag) async {
    isar.writeTxn(() async {
      await transaction.tags.load();
      transaction.tags.add(tag);
      await transaction.tags.save();
      await isar.transactions.put(transaction);
    });
  }

  Future<void> removeTag(Tag t) async {
    await isar.writeTxn(() async {
      await isar.tags.delete(t.id);
    });
  }

  Future<void> addTransaction(Transaction t) async {
    var aivaiableTags = getAllTags();
    await isar.writeTxn(() async {
      await isar.transactions.put(t);
      await t.tags.load();
      t.tags.removeAll(aivaiableTags.where((Tag tag) => !t.tempTag.contains(tag)).toList());
      t.tags.addAll(t.tempTag);
      await t.tags.save();
      await isar.transactions.put(t);
    });
  }

  Future<void> removeTransaction(Transaction t) async {
    await isar.writeTxn(() async {
      await isar.transactions.delete(t.id);
    });
  }

  double getBalnceForThisMonth({DateTime? date}) {
    date ??= DateTime.now();

    final DateTime startOfMonth = DateTime(date.year, date.month, 1);
    final DateTime endOfMonth = DateTime(date.year, date.month + 1, 1).subtract(const Duration(days: 1));
    double balance = 0.0;

    isar.txnSync(() {
      var list = isar.transactions.filter().dateBetween(startOfMonth, endOfMonth).findAllSync().toList();
      balance = list.fold<double>(0, (previusValue, Transaction t) => previusValue += t.price * (t.type == TransactionType.income ? 1 : -1));
    });
    return balance;
  }

  List<Transaction> getTransitionsForThisMonth({DateTime? date}) {
    date ??= DateTime.now();

    final DateTime startOfMonth = DateTime(date.year, date.month, 1);
    final DateTime endOfMonth = DateTime(date.year, date.month + 1, 1).subtract(const Duration(days: 1));
    List<Transaction> list = [];

    isar.txnSync(() {
      list = isar.transactions.filter().dateBetween(startOfMonth, endOfMonth).findAllSync().toList();
    });
    return list;
  }

  /// CHAT GPT code
  Future<Map<String, Map<String, int>>> getTransactionsGroupedByYearAndMonth() async {
    // Prelevare tutte le transazioni dal database
    final transactions = await isar.transactions.where().findAll();

    // Mappa per memorizzare i risultati
    Map<String, Map<String, int>> result = {};

    // Itera attraverso ogni transazione
    for (var transaction in transactions) {
      // Estrai anno e mese dalla data della transazione
      final year = transaction.date!.year.toString();
      final month = MonthHelper.getMonthName(transaction.date!.month);

      // Controlla se l'anno è già presente nella mappa
      if (!result.containsKey(year)) {
        result[year] = {};
      }

      // Controlla se il mese è già presente per quell'anno, altrimenti lo imposta a 0
      if (!result[year]!.containsKey(month)) {
        result[year]![month] = 0;
      }

      // Incrementa il conteggio delle transazioni per quel mese
      result[year]![month] = result[year]![month]! + 1;
    }

    return result;
  }

  int getTransactionsCount() {
    return isar.transactions.where().findAllSync().length;
  }

  int getTagsCount() {
    return isar.tags.where().findAllSync().length;
  }
}
