import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uth_task/app/models/savings_goal.dart';

class SavingsController extends GetxController {
  var savingsGoals = <SavingsGoal>[].obs;
  final formKeySavings = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController savedAmountController = TextEditingController();
  final TextEditingController date = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final box = GetStorage();
  var uid;

  @override
  void onInit() {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      uid = user.uid;
      fetchSavingsGoals(uid);
    } else {
      Get.snackbar("Error", "User is not logged in.");
    }
  }

  void fetchSavingsGoals(uid) {
    print('Fetching savings goals for UID: $uid');

    _firestore.collection('users').doc(uid).collection('savings_goals').snapshots().listen((snapshot) {
      final goals = snapshot.docs.map((doc) {
        final data = doc.data();
        DateTime parsedDate;
        if (data['date'] is Timestamp) {
          parsedDate = (data['date'] as Timestamp).toDate();
        } else if (data['date'] is String) {
          parsedDate = DateTime.parse(data['date']);
        } else {
          parsedDate = DateTime.now();
        }

        return SavingsGoal(
          id: doc.id,
          name: data['name'] ?? '',
          targetAmount: (data['targetAmount'] as num?)?.toDouble() ?? 0.0,
          savedAmount: (data['savedAmount'] as num?)?.toDouble() ?? 0.0,
          date: parsedDate,
          uid: data['uid'] ?? '',
        );
      }).toList();

      savingsGoals.assignAll(goals);
      box.write('savingsGoals', goals.map((goal) => goal.toJson()).toList());
    });

    var localData = box.read<List>('savingsGoals');
    if (localData != null && localData.isNotEmpty) {
      savingsGoals.value = localData.map((data) => SavingsGoal.fromJson(data)).toList();
    }
  }

  Future<void> addSavingsGoal(SavingsGoal goal) async {
    try {
      await _firestore.collection('users').doc(uid).collection('savings_goals').add(goal.toJson());
      Get.back();
      nameController.clear();
      targetAmountController.clear();
      savedAmountController.clear();
      date.clear();
    } catch (e) {
      // Get.snackbar("Error adding savings goal", 'Please try again later');
      print('Error adding savings goal: $e');
    }
  }

  Future<void> updateSavingsGoal(SavingsGoal goal) async {
    try {
      await _firestore.collection('users').doc(uid).collection('savings_goals').doc(goal.id).update(goal.toJson());
    } catch (e) {
      Get.snackbar("Error updating savings goal", 'Please try again later');
      print('Error updating savings goal: $e');
    }
  }

  Future<void> removeSavingsGoal(String id) async {
    try {
      await _firestore.collection('users').doc(uid).collection('savings_goals').doc(id).delete();
    } catch (e) {
      Get.snackbar("Error removing savings goal", 'Please try again later');
      print('Error removing savings goal: $e');
    }
  }
}
