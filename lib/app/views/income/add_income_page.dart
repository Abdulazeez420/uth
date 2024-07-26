import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uth_task/app/controllers/income_controller.dart';
import 'package:uth_task/app/models/income.dart';
import 'package:uth_task/app/constant/appColors.dart';

class AddIncomePage extends StatelessWidget {
  final IncomeController incomeController = Get.find();
  final Income? income;
  final DateTime? date;

  AddIncomePage({Key? key, this.income, this.date}) : super(key: key) {
    if (income != null) {
      incomeController.sourceController.text = income!.source;
      incomeController.amountController.text = income!.amount.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: incomeController.formKeyIncome,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: incomeController.sourceController,
                  decoration: InputDecoration(
                    labelText: 'Source',
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
                      return 'Please enter a source';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: incomeController.amountController,
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
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.btnColor),
                    textStyle: MaterialStateProperty.all(
                        const TextStyle(fontSize: 15)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    try {
                      if (incomeController.formKeyIncome.currentState
                              ?.validate() ??
                          false) {
                        final newIncome = Income(
                          uid: incomeController.uid,
                          id: income?.id ?? date.toString(),
                          source: incomeController.sourceController.text,
                          amount: double.parse(
                              incomeController.amountController.text),
                          date: date ?? DateTime.now(),
                        );

                        if (income == null) {
                          incomeController.addIncome(newIncome);
                        } else {
                          incomeController.updateIncome(newIncome);
                        }

                       
                      }
                    } catch (e) {
                      print('Error: $e');
                    }
                    
                  },
                  child: Text(income == null ? 'Add Income' : 'Update Income',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
