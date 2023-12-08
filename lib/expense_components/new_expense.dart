import 'package:expense_tracker_app/expense.dart';
import 'package:expense_tracker_app/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NewExpense extends StatefulWidget {
  const NewExpense(
      {super.key, required this.onAddExpense, required this.isDarkMode});

  final void Function(Expense expense) onAddExpense;
  final bool isDarkMode;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  // #TODO - onChange function

  // #TODO - titileController & _amountController with TextEditingController
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  // #TODO - selectedCategory
  Category _selectedCategory = Category.food;
  // #TODO - selectedDate
  DateTime? _selectedDate;
  final formatter = DateFormat.yMd();

  // #TODO - dispose
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  // #TODO - showDatePicker Function
  _showDateTimePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    var pickedDate = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: firstDate,
        lastDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  // #TODO - onSubmit Function with validations
  void _onSubmit() {
    if (_titleController.text.isEmpty ||
        _amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null ||
        _selectedDate == null) {
      showDialog(
          context: context,
          builder: ((ctx) => AlertDialog(
                  title: const Row(children: [Icon(Icons.error, color: Colors.red), Text(' Invalid Input(s)')]),
                  content: const Text(
                      'check whether the entered values are correct!'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                        child: const Text('Okay'))
                  ])));
      return;
    }
    widget.onAddExpense(Expense(
        id: const Uuid().v4(),
        title: _titleController.text,
        amount: double.parse(_amountController.text),
        date: _selectedDate!,
        category: _selectedCategory));

    Future.delayed(Duration.zero, () {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: ((ctx) => AlertDialog(
                title: const Row(children: [Text('Success '), Icon(Icons.check_box, color: Colors.green)]),
                content: const Text('Expense added successfully!!'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: const Text("Okay"))
                ],
              )));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.keyboard_backspace_rounded),
            ),
            title: Text("Add new Expense",
                style: GoogleFonts.poppins(
                    color: Colors.green[100], fontSize: 22)),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  onChanged: (e) => {},
                  maxLength: 50,
                  decoration: const InputDecoration(
                    label: Text('Title'),
                  ),
                ),

                // #TODO - Amount with keyboardType: TextInputType.number
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  maxLength: 10,
                  decoration: const InputDecoration(
                      prefixText: "LKR ", label: Text("Amount")),
                ),

                // #TODO - Date Picker Selection Icon Button with a Text
                Row(
                  children: [
                    Text(_selectedDate != null
                        ? formatter.format(_selectedDate!)
                        : "No date selected"),
                    IconButton(
                        onPressed: () {
                          _showDateTimePicker();
                        },
                        icon: const Icon(Icons.calendar_month_outlined))
                  ],
                ),
                // #TODO - Category Dropdown
                DropdownButton(
                    value: _selectedCategory,
                    items: Category.values
                        .map((category) => DropdownMenuItem(
                            value: category,
                            child: Text(category.name.toUpperCase())))
                        .toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _selectedCategory = value;
                      });
                    }),

                Row(
                  // #TDOD - Add Cancel TextButton with Navigator.pop(context)
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel")),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _onSubmit,
                      child: const Text('Save Expense'),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
