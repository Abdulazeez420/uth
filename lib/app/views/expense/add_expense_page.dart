import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_task/app/controllers/expense_controller.dart';
import 'package:uth_task/app/models/expense.dart';
import 'package:uth_task/app/constant/appColors.dart';

class AddExpensePage extends StatelessWidget {
  final ExpenseController expenseController = Get.find();
  final Expense? expense;
  final DateTime? date;

  AddExpensePage({super.key, this.expense, this.date}) {
    if (expense != null) {
      expenseController.descriptionController.text = expense!.description;
      expenseController.amountController.text = expense!.amount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 600, // Maximum width for the form
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
               
                  Form(
                    key: expenseController.formKeyExpense,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: expenseController.descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: expenseController.amountController,
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: const BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an amount';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(AppColors.btnColor),
                            textStyle: MaterialStateProperty.all(const TextStyle(fontSize: 15)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            if (expenseController.formKeyExpense.currentState?.validate() ?? false) {
                              final expense = Expense(
                                uid: expenseController.uid,
                                id: this.expense?.id ?? date.toString(),
                                description: expenseController.descriptionController.text,
                                amount: double.parse(expenseController.amountController.text),
                                date: this.expense?.date ?? date!,
                              );
                              if (this.expense == null) {
                                expenseController.addExpense(expense);
                              } else {
                                expenseController.updateExpense(expense);
                              }
                             
                            }
                          },
                          child: Text(
                            this.expense == null ? 'Add Expense' : 'Update Expense',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
