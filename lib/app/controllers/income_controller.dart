import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uth_task/app/models/income.dart';

class IncomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final box = GetStorage();
  var incomes = <Income>[].obs;
  final formKeyIncome = GlobalKey<FormState>();
  final TextEditingController sourceController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  var uid;

  @override
  void onInit() {
    super.onInit();
    final user = auth.currentUser;

    if (user != null) {
      uid = user.uid;
      print("is uid :${uid}");
      fetchIncomes(uid);
    } else {
      Get.snackbar("Error", "User is not logged in.");
    }
  }

  void fetchIncomes(uid) {
  print('Fetching incomes for UID: $uid');

  _firestore.collection('users').doc('$uid').collection('incomes').snapshots().listen((snapshot) {
    final incomeList = snapshot.docs.map((doc) {
      final data = doc.data();
      DateTime incomeDate;

      // Check if date is a Timestamp or String
      if (data['date'] is Timestamp) {
        incomeDate = (data['date'] as Timestamp).toDate();
      } else if (data['date'] is String) {
        incomeDate = DateTime.parse(data['date'] as String);
      } else {
        incomeDate = DateTime.now(); // Handle unexpected formats
      }

      return Income(
        id: doc.id,
        source: data['source'] ?? '',
        amount: (data['amount'] as num?)?.toDouble() ?? 0.0,
        date: incomeDate,
        uid: data['uid'] ?? '',
      );
    }).toList();

    incomes.assignAll(incomeList);
    box.write('incomes', incomeList.map((income) => income.toJson()).toList());
  }, onError: (error) {
    // Get.snackbar("Error", "Failed to fetch incomes: $error");
  });

  var localData = box.read<List>('incomes');
  if (localData != null && localData.isNotEmpty) {
    incomes.value = localData.map((data) => Income.fromJson(data)).toList();
  }
}

  void addIncome(Income income) {
    income.uid = uid;
    _firestore.collection('users').doc(uid).collection('incomes').add(income.toJson());
     Get.back();
    sourceController.clear();
    amountController.clear();
  }

  void updateIncome(Income income) {
    income.uid = uid;
    _firestore.collection('users').doc(uid).collection('incomes').doc(income.id).update(income.toJson());
  }

  void deleteIncome(Income income) {
    _firestore.collection('users').doc(uid).collection('incomes').doc(income.id).delete();
  }
}
