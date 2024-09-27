import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.I;

void initSingleton() {
  locator.registerSingleton(DatabaseBridge());
  locator.registerSingleton(TransactionController());
}
