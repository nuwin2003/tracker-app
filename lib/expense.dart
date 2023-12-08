import 'package:expense_tracker_app/expense_components/expense_list.dart';
import 'package:expense_tracker_app/expense_components/new_expense.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:expense_tracker_app/util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const filePath = 'assets/json/expense_data.json';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

bool isDarkMode = false;

class _ExpensesState extends State<Expenses> {
  List<Expense> expenses = [];

  @override
  void initState() {
    _loadExpenses();
    super.initState();
  }

  void _loadExpenses() async {
    List<Expense> loadedExpenses =
        (await readJsonFile(filePath)).map((dynamic item) {
      return Expense.fromJson(item as Map<String, dynamic>);
    }).toList();
    setState(() {
      expenses = loadedExpenses;
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) => NewExpense(onAddExpense: addExpense, isDarkMode: isDarkMode));
  }

  // #TODO - addExpense function to expense List and pass to NewExpense widget;
  void addExpense(Expense expense) {
    setState(() {
      expenses.add(expense);
    });
  }

  // #TODO - removeExpense function to expense List and pass to NewExpense widget;
  void removeExpense(Expense expense) {
    setState(() {
      expenses.remove(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flutter Expense Tracker',
              style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.green[100],
                  fontWeight: FontWeight.w600)),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
                icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode)),
            IconButton(
              onPressed: _openAddExpenseOverlay,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(child: ExpensesList(expenses: expenses, onRemoveExpense: removeExpense)),
          ],
        ),
      ),
    );
  }
}
