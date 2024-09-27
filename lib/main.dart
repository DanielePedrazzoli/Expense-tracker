import 'dart:developer';

import 'package:expense_tracker/controller/database_bridge.dart';
import 'package:expense_tracker/controller/singleton/lcoator.dart';
import 'package:expense_tracker/controller/transaction_controller.dart';
import 'package:expense_tracker/view/pages/Tag/edit_tag.dart';
import 'package:expense_tracker/view/pages/Tag/tag_list.dart';
import 'package:expense_tracker/view/pages/Transaction/edit_transaction.dart';
import 'package:expense_tracker/view/pages/Transaction/transaction_history.dart';
import 'package:expense_tracker/view/pages/home/home.dart';
import 'package:expense_tracker/view/pages/information/information_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initSingleton();
  await locator<DatabaseBridge>().init();

  runApp(
    MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xff7A1CAC),
          secondary: Color(0xffAD49E1),
          tertiary: Color(0xffEBD3F8),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          surface: Color.fromARGB(255, 25, 25, 25),
          onSurface: Colors.white,
          surfaceContainer: Color.fromARGB(255, 35, 35, 35),
          onInverseSurface: Colors.black,
          brightness: Brightness.dark,
          outlineVariant: Color.fromARGB(255, 78, 78, 78),
          onSurfaceVariant: Colors.white,
          surfaceBright: Colors.grey,
          surfaceContainerLow: Color.fromARGB(255, 32, 32, 32),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          iconTheme: WidgetStateProperty.resolveWith(
            (state) {
              if (state.contains(WidgetState.selected)) {
                return const IconThemeData(color: Colors.white);
              }
              return const IconThemeData(color: Color.fromARGB(153, 255, 255, 255));
            },
          ),
        ),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 113, 113, 113),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 113, 113, 113),
              ),
            ),
            labelStyle: TextStyle(color: Colors.white)),
      ),
      home: const Application(),
    ),
  );
}

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  int selectedIndex = 0;
  late TransactionController _transactionController;

  Widget _getPage() {
    switch (selectedIndex) {
      case 0:
        return Home(controller: _transactionController);
      case 1:
        return TransactionHistory(controller: _transactionController);
      case 2:
        return const TagList();
      case 3:
        return const InformationPage();
      default:
        return const Placeholder();
    }
  }

  Widget? _retunFAB() {
    switch (selectedIndex) {
      case 0:
        return FloatingActionButton(
          key: const ValueKey("FAB"),
          child: const Icon(Icons.add),
          onPressed: () async {
            _goTo(const EditTransaction(isNewTransaction: true));
          },
        );

      case 2:
        return FloatingActionButton(
          key: const ValueKey("FAB"),
          child: const Icon(Icons.add),
          onPressed: () async {
            _goTo(const EditTag(isNewTag: true));
          },
        );
      default:
        return null;
    }
  }

  Future<void> _goTo(Widget page) async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _transactionController = locator<TransactionController>();

    initAsync();
  }

  Future<void> initAsync() async {
    await _transactionController.loadData();
    log("init mai widget done");
  }

  // primary color : Color.fromARGB(255, 97, 17, 150) 7A1CAC
  /// https://colorhunt.co/palette/2e073f7a1cacad49e1ebd3f8
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int newDestinatiom) {
          setState(() {
            selectedIndex = newDestinatiom;
          });
        },
        selectedIndex: selectedIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.show_chart), label: "Movimenti"),
          NavigationDestination(icon: Icon(Icons.label_outline_rounded), label: "Tags"),
          NavigationDestination(icon: Icon(Icons.info_outline), label: "Informazioni"),
        ],
      ),
      body: _getPage(),
      floatingActionButton: _retunFAB(),
    );
  }
}
