import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_task/app/controllers/savings_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/expense_controller.dart';
import 'app/controllers/income_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  // Initialize controllers
  Get.put(AuthController());
  Get.put(IncomeController());
  Get.put(SavingsController());
  Get.put(ExpenseController());

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
    theme: ThemeData(
      primaryColor: const Color(0xFF448AFF),
    ),
  ));
}
