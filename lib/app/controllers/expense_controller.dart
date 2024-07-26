import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_task/app/models/expense.dart';

class ExpenseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();
  var expenses = <Expense>[].obs;
  final formKeyExpense = GlobalKey<FormState>();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  var uid;

  @override
  void onInit() {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      fetchExpenses(uid);
    } else {
      Get.snackbar("Error", "User is not logged in.");
    }
  }

void fetchExpenses(uid) {
  print('Fetching expenses for UID: $uid');

  _firestore.collection('users').doc(uid).collection('expenses').snapshots().listen((snapshot) {
    final expenseList = snapshot.docs.map((doc) {
      final data = doc.data();
      DateTime expenseDate;

      if (data['date'] is Timestamp) {
        expenseDate = (data['date'] as Timestamp).toDate();
      } else if (data['date'] is String) {
        expenseDate = DateTime.parse(data['date'] as String);
      } else {
        expenseDate = DateTime.now(); // Handle unexpected formats
      }

      return Expense(
        id: doc.id,
        description: data['description'] ?? '',
        amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
        date: expenseDate,
        uid: data['uid'] ?? '',
      );
    }).toList();

    expenses.assignAll(expenseList);
    box.write('expenses', expenseList.map((expense) => expense.toJson()).toList());
  }, onError: (error) {
    // Get.snackbar("Error", "Failed to fetch expenses: $error");
  });

  var localData = box.read<List>('expenses');
  if (localData != null && localData.isNotEmpty) {
    expenses.value = localData.map((data) => Expense.fromJson(data)).toList();
  }
}

  void addExpense(Expense expense) {
    _firestore.collection('users').doc(uid).collection('expenses').add(expense.toJson());
    Get.back();
    descriptionController.clear();
    amountController.clear();
  }

  void updateExpense(Expense expense) {
    _firestore.collection('users').doc(uid).collection('expenses').doc(expense.id).update(expense.toJson());
  }

  void deleteExpense(Expense expense) {
    _firestore.collection('users').doc(uid).collection('expenses').doc(expense.id).delete();
  }
}
