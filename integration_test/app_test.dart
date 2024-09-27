import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/view/pages/Transaction/edit_transaction.dart';
import 'package:expense_tracker/view/pages/Transaction/transaction_history.dart';
import 'package:expense_tracker/view/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// run test with:  flutter test integration_test/app_test.dart --dart-define=INTEGRATION_TEST=true

bool _isBalanceCorrect(double balanceValue) {
  Text balance = find.byKey(const ValueKey("month_balance")).evaluate().single.widget as Text;
  return balance.data == balanceValue.toString();
}

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    initSingleton();
    await locator<DatabaseBridge>().init();
    await locator<DatabaseBridge>().clearDatabase();
  });

  group('Managing transaction', () {
    testWidgets('Add a transaciton', (tester) async {
      // Load app widget.
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff6369D1),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          home: const Placeholder(),
        ),
      );

      // check initial balance
      expect(_isBalanceCorrect(0.0), true);

      // Finds the floating action button to tap on.
      final fab = find.byKey(const ValueKey('add_transaction'));
      await tester.tap(fab);
      await tester.pumpAndSettle();

      // Verify that the navigation happened
      expect(find.byType(EditTransaction), findsOneWidget);

      // input price
      await tester.enterText(find.byKey(const ValueKey("price")), "1000");
      await tester.pumpAndSettle();

      // save the transaction
      final saveButton = find.byKey(const ValueKey('save'));
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify that the navigation happened
      expect(find.byType(Home), findsOneWidget);

      // check again balance, should be 10.0 euros
      expect(_isBalanceCorrect(10.0), true);
    });

    testWidgets('Delete a transaciton', (tester) async {
      // Load app widget.
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff6369D1),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              border: OutlineInputBorder(),
            ),
          ),
          home: const Placeholder(),
        ),
      );

      // check initial balance
      expect(_isBalanceCorrect(10.0), true);

      // open the drawer to navigate in the correct page
      final ScaffoldState state = tester.firstState(find.byType(Scaffold));
      state.openDrawer();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey("history")));
      await tester.pumpAndSettle();

      // Verify that the navigation happened
      expect(find.byType(TransactionHistory), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);

      // find a valida tile and tap on it
      var transactionTile = find.byType(ListTile).first;
      await tester.tap(transactionTile);
      await tester.pumpAndSettle();

      // Verify that the navigation happened
      expect(find.byType(EditTransaction), findsOneWidget);

      // check that the delete button exist this time
      var deleteButton = find.byKey(const ValueKey("delete"));
      expect(deleteButton, findsOneWidget);

      // delete the transaction
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // press cancel
      var cancelButton = find.byKey(const ValueKey("cancel"));
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // verify that cancel does not delete the transaction and
      // just close the dialog
      expect(find.byType(Dialog), findsNothing);

      // go to the histoty page to check if the transactio is still there
      await tester.tap(find.byKey(const ValueKey("quit")));
      await tester.pumpAndSettle();
      expect(find.byType(TransactionHistory), findsOneWidget);
      expect(find.byType(ListTile), findsOneWidget);

      // Navigate again in the edid page
      transactionTile = find.byType(ListTile).first;
      await tester.tap(transactionTile);
      await tester.pumpAndSettle();

      // press delete and this time delete the transaciton
      deleteButton = find.byKey(const ValueKey("delete"));
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      cancelButton = find.byKey(const ValueKey("confirm"));
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      // this should popped in the history page and no tile should be avaiable
      expect(find.byType(EditTransaction), findsNothing);
      expect(find.byType(TransactionHistory), findsOneWidget);
      expect(find.byType(ListTile), findsNothing);

      // back again in the home page
      await tester.tap(find.byKey(const ValueKey("quit")));
      await tester.pumpAndSettle();

      // check balance again and this time should be 0.0
      expect(_isBalanceCorrect(0.0), true);
    });
  });
}
