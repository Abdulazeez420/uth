// ignore_for_file: depend_on_referenced_packages, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uth_task/app/constant/appColors.dart';
import 'package:uth_task/app/controllers/auth_controller.dart';
import 'package:uth_task/app/controllers/expense_controller.dart';
import 'package:uth_task/app/controllers/income_controller.dart';
import 'package:uth_task/app/controllers/savings_controller.dart'; // Import the SavingsController
import 'package:intl/intl.dart';
import 'package:uth_task/app/models/savings_goal.dart';

import 'package:uth_task/app/services/pdf_report.dart';
import 'package:uth_task/app/views/expense/add_expense_page.dart';
import 'package:uth_task/app/views/income/add_income_page.dart';
import 'package:uth_task/app/views/savings/add_savings_goal_page.dart';
import 'package:jiffy/jiffy.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final IncomeController incomeController = Get.find();
  final ExpenseController expenseController = Get.find();
  final SavingsController savingsController = Get.find();
  final AuthController authController = Get.find();
  DateTime _selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
   TabController ?_tabController;
  CalendarFormat calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _tabController=
        TabController(length: 4, vsync: this); // Update tab length to 4
    _tabController!.addListener(_handleTabSelection);
    incomeController.onInit();
    expenseController.onInit();
    savingsController.onInit();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    setState(() {
      if (_tabController!.index == 0) {
        calendarFormat = CalendarFormat.week;
      } else if (_tabController!.index == 1) {
        calendarFormat = CalendarFormat.month;
      } else {
        calendarFormat = CalendarFormat.month;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          onPressed: () => bottomModal(context),
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(50, 236, 193, 0.096),
          title: const Text('Day to Day Expenses'),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          actions: [
            IconButton(
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              onPressed: () async {
                await generatePdfReport(
                    incomeController.incomes, expenseController.expenses);
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.red),
              onPressed: () async {
                await authController.signOut();
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildDateHeader(),
              const SizedBox(height: 20),
              TabBar(
                controller: _tabController!,
                labelColor: Colors.white,
                indicatorPadding: const EdgeInsets.all(0.0),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelPadding: const EdgeInsets.only(left: 0.0, right: 0.0),
                indicator: const ShapeDecoration(
                    shape: RoundedRectangleBorder(),
                    gradient:
                        LinearGradient(colors: [Colors.blue, Colors.green])),
                tabs: const <Widget>[
                  Tab(text: 'Daily'),
                  Tab(text: 'Monthly'),
                  Tab(text: 'Yearly'),
                  Tab(text: 'Savings'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController!,
                  children: <Widget>[
                    buildDailyDataList(),
                    buildMonthlyDataList(),
                    buildYearlyDataList(),
                    buildSavingsDataList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDateHeader() {
    return Card(
      color: Colors.blueAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_circle_left_outlined,
                size: 45, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_tabController!.index == 0) {
                  _selectedDay = DateTime(_selectedDay.year, _selectedDay.month,
                      _selectedDay.day - 1);
                } else if (_tabController!.index == 1) {
                  _selectedDay = DateTime(_selectedDay.year,
                      _selectedDay.month - 1, _selectedDay.day);
                } else {
                  _selectedDay = DateTime(_selectedDay.year - 1,
                      _selectedDay.month, _selectedDay.day);
                }
                focusedDay = _selectedDay;
              });
            },
          ),
          Text(
            _tabController!.index == 0
                ? '${_selectedDay.day}, ${Jiffy.parse(_selectedDay.toString()).MMMM}, ${_selectedDay.year}\n ${Jiffy.parse(_selectedDay.toString()).EEEE}'
                : _tabController!.index == 1
                    ? '${Jiffy.parse(_selectedDay.toString()).MMMM} ${_selectedDay.year}'
                    : '${_selectedDay.year}',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_circle_right_outlined,
                size: 45, color: Colors.white),
            onPressed: () {
              setState(() {
                if (_tabController!.index == 0) {
                  _selectedDay = DateTime(_selectedDay.year, _selectedDay.month,
                      _selectedDay.day + 1);
                } else if (_tabController!.index == 1) {
                  _selectedDay = DateTime(_selectedDay.year,
                      _selectedDay.month + 1, _selectedDay.day);
                } else {
                  _selectedDay = DateTime(_selectedDay.year + 1,
                      _selectedDay.month, _selectedDay.day);
                }
                focusedDay = _selectedDay;
              });
            },
          ),
        ],
      ),
    );
  }

  Future bottomModal(BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: DefaultTabController(
              length: 3,
              initialIndex: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const TabBar(
                    labelColor: Colors.white,
                    indicatorPadding: EdgeInsets.all(0.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                    indicator: ShapeDecoration(
                        shape: RoundedRectangleBorder(),
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.green])),
                    tabs: <Widget>[
                      Tab(text: 'Income'),
                      Tab(text: 'Expense'),
                      Tab(text: 'Savings'),
                    ],
                  ),
                  Container(
                    height: Get.height / 1.8,
                    child: TabBarView(
                      children: <Widget>[
                        AddIncomePage(date: _selectedDay),
                        AddExpensePage(date: _selectedDay),
                        AddSavingsGoalPage(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDailyDataList() {
    return Obx(() {
      final dailyIncomes = incomeController.incomes
          .where((income) => isSameDay(income.date, _selectedDay))
          .toList();
      final dailyExpenses = expenseController.expenses
          .where((expense) => isSameDay(expense.date, _selectedDay))
          .toList();

      final totalIncome =
          dailyIncomes.fold(0.0, (sum, item) => sum + item.amount);
      final totalExpense =
          dailyExpenses.fold(0.0, (sum, item) => sum + item.amount);
      final balance = totalIncome - totalExpense;

      // final lastIncomeIndex = dailyIncomes.isNotEmpty ? dailyIncomes.length - 1 : -1;
      final lastExpenseIndex =
          dailyExpenses.isNotEmpty ? dailyExpenses.length - 1 : -1;

      return Column(
        children: [
          Card(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.blueAccent,
              ),
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Income (Credit): ₹${totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      'Total Expenses (Debit): ₹${totalExpense.toStringAsFixed(2)}',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    'Balance: ₹${balance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Card(
              child: ListView(
                children: [
                  ListTile(
                    title: const Text('C/F'),
                    trailing: Text('₹${balance.toStringAsFixed(2)}',
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  Card(
                    color: Colors.blueAccent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Total Income (Credit)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: dailyIncomes.isEmpty,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("+ Add to your Income,Expense & Savings"),
                    ),
                  ),
                  ...dailyIncomes.map((income) {
                    return ListTile(
                      title: Text(income.source),
                      trailing: Text('₹${income.amount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.green)),
                      onLongPress: () {
                        Get.defaultDialog(
                          backgroundColor: Colors.white,
                          title: "Delete Income",
                          middleText:
                              "Are you sure you want to delete this income?",
                          textConfirm: "Yes",
                          textCancel: "No",
                          onConfirm: () {
                            incomeController.deleteIncome(income);
                            Get.back();
                          },
                        );
                      },
                    );
                  }).toList(),
                  Card(
                    color: Colors.blueAccent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text(
                        'Total Expense (Debit)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ...dailyExpenses.map((expense) {
                    final isLast =
                        dailyExpenses.indexOf(expense) == lastExpenseIndex;
                    return Padding(
                      padding: EdgeInsets.only(bottom: isLast ? 80 : 0),
                      child: ListTile(
                        title: Text(expense.description),
                        trailing: Text('₹${expense.amount.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red)),
                        onLongPress: () {
                          Get.defaultDialog(
                            backgroundColor: Colors.white,
                            title: "Delete Expense",
                            middleText:
                                "Are you sure you want to delete this expense?",
                            textConfirm: "Yes",
                            textCancel: "No",
                            onConfirm: () {
                              expenseController.deleteExpense(expense);
                              Get.back();
                            },
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildMonthlyDataList() {
    return Obx(() {
      final monthlyIncomes = incomeController.incomes
          .where((income) =>
              income.date.year == _selectedDay.year &&
              income.date.month == _selectedDay.month)
          .toList();
      final monthlyExpenses = expenseController.expenses
          .where((expense) =>
              expense.date.year == _selectedDay.year &&
              expense.date.month == _selectedDay.month)
          .toList();

      // Group incomes and expenses by date
      final dailyDataMap = <DateTime, Map<String, double>>{};

      for (var income in monthlyIncomes) {
        final date =
            DateTime(income.date.year, income.date.month, income.date.day);
        dailyDataMap[date] ??= {'income': 0, 'expense': 0};
        dailyDataMap[date]!['income'] =
            (dailyDataMap[date]!['income'] ?? 0) + income.amount;
      }

      for (var expense in monthlyExpenses) {
        final date =
            DateTime(expense.date.year, expense.date.month, expense.date.day);
        dailyDataMap[date] ??= {'income': 0, 'expense': 0};
        dailyDataMap[date]!['expense'] =
            (dailyDataMap[date]!['expense'] ?? 0) + expense.amount;
      }

      final totalIncome =
          monthlyIncomes.fold(0.0, (sum, item) => sum + item.amount);
      final totalExpense =
          monthlyExpenses.fold(0.0, (sum, item) => sum + item.amount);
      final balance = totalIncome - totalExpense;

      final dailyDates = dailyDataMap.keys.toList()
        ..sort((a, b) => a.compareTo(b));
      final lastIndex = dailyDates.isNotEmpty ? dailyDates.length - 1 : -1;

      return Column(
        children: [
          Card(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Income (Credit): ₹${totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      'Total Expenses (Debit): ₹${totalExpense.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text(
                    'Balance: ₹${balance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dailyDates.length,
              itemBuilder: (context, index) {
                final date = dailyDates[index];
                final dateIncome = dailyDataMap[date]!['income'] ?? 0;
                final dateExpense = dailyDataMap[date]!['expense'] ?? 0;
                final dateBalance = dateIncome - dateExpense;

                final dateFormat = DateFormat('dd MMM yyyy');
                final isLastIndex = index == lastIndex;

                return GestureDetector(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Delete Data'),
                          content: Text(
                              'Are you sure you want to delete all data for ${DateFormat('dd MMM yyyy').format(date)}?'),
                          actions: [
                            TextButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text('Delete'),
                              onPressed: () {
                                final dailyIncomes = incomeController.incomes
                                    .where((income) =>
                                        isSameDay(income.date, date))
                                    .toList();
                                final dailyExpenses = expenseController.expenses
                                    .where((expense) =>
                                        isSameDay(expense.date, date))
                                    .toList();

                                for (var income in dailyIncomes) {
                                  incomeController.deleteIncome(
                                      income); // Assumes a deleteIncome method exists
                                }

                                for (var expense in dailyExpenses) {
                                  expenseController.deleteExpense(
                                      expense); // Assumes a deleteExpense method exists
                                }

                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLastIndex ? 80 : 0),
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                dateFormat.format(date),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Incomes:',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.green),
                            ),
                            Text(
                              '₹${dateIncome.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.green, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Expenses:',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.red),
                            ),
                            Text(
                              '₹${dateExpense.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Balance: ₹${dateBalance.toStringAsFixed(2)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget buildYearlyDataList() {
    return Obx(() {
      final yearlyIncomes = incomeController.incomes
          .where((income) => income.date.year == _selectedDay.year)
          .toList();
      final yearlyExpenses = expenseController.expenses
          .where((expense) => expense.date.year == _selectedDay.year)
          .toList();

      final totalIncome =
          yearlyIncomes.fold(0.0, (sum, item) => sum + item.amount);
      final totalExpense =
          yearlyExpenses.fold(0.0, (sum, item) => sum + item.amount);
      final balance = totalIncome - totalExpense;

      final monthlySummary = List.generate(12, (index) {
        final month = index + 1;
        final monthlyIncome = yearlyIncomes
            .where((income) => income.date.month == month)
            .fold(0.0, (sum, item) => sum + item.amount);
        final monthlyExpense = yearlyExpenses
            .where((expense) => expense.date.month == month)
            .fold(0.0, (sum, item) => sum + item.amount);
        return {
          'month': month,
          'income': monthlyIncome,
          'expense': monthlyExpense,
          'balance': monthlyIncome - monthlyExpense,
        };
      })
          .where((monthData) =>
              monthData['income'] != 0.0 || monthData['expense'] != 0.0)
          .toList();

      final lastIndex =
          monthlySummary.isNotEmpty ? monthlySummary.length - 1 : -1;

      return Column(
        children: [
          Card(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.blueAccent,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Income (Credit): ₹${totalIncome.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      'Total Expenses (Debit): ₹${totalExpense.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    'Balance: ₹${balance.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: lastIndex != -1
                      ? 80.0
                      : 0), // Add bottom padding conditionally
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Card(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Month')),
                      DataColumn(label: Text('Income (Credit)')),
                      DataColumn(label: Text('Expense (Debit)')),
                      DataColumn(label: Text('Balance')),
                    ],
                    rows: monthlySummary.asMap().entries.map((entry) {
                      // final index = entry.key;
                      final monthData = entry.value;
                      // final isLastIndex = index == lastIndex;

                      return DataRow(
                        cells: [
                          DataCell(Text(
                            DateFormat('MMM').format(DateTime(
                                0, int.parse(monthData['month'].toString()))),
                          )),
                          DataCell(Text(
                            '₹${monthData['income']!.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.green),
                          )),
                          DataCell(Text(
                            '₹${monthData['expense']!.toStringAsFixed(2)}',
                            style: const TextStyle(color: Colors.red),
                          )),
                          DataCell(Text(
                            '₹${monthData['balance']!.toStringAsFixed(2)}',
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildSavingsDataList() {
    return Obx(() {
      final savingsGoals = savingsController.savingsGoals;

      // Group savings goals by date
      final groupedGoals = <DateTime, List<SavingsGoal>>{};
      for (final goal in savingsGoals) {
        final date = DateTime(goal.date.year, goal.date.month, goal.date.day);
        if (!groupedGoals.containsKey(date)) {
          groupedGoals[date] = [];
        }
        groupedGoals[date]!.add(goal);
      }

      final sortedDates = groupedGoals.keys.toList()..sort();

      return sortedDates.isNotEmpty
          ? ListView.builder(
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final goalsForDate = groupedGoals[date]!;

                return Padding(
                  padding: EdgeInsets.only(
                      bottom: index == sortedDates.length - 1 ? 80.0 : 0),
                  child: Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(
                              'Date: ${Jiffy.parse(date.toString()).format(pattern: 'yyyy-MM-dd')}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: goalsForDate.map((goal) {
                              return Text(
                                '\nGoal: ${goal.name}\nTarget Amount: ₹${goal.targetAmount}\nSaved Amount: ₹${goal.savedAmount}',
                                style: TextStyle(fontSize: 16),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Assuming you want to remove all goals for this date
                                for (var goal in goalsForDate) {
                                  savingsController.removeSavingsGoal(goal.id);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Card(
              child: Center(
                child: Text(
                  "+ Add to your Income, Expense & Savings",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
    });
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}
