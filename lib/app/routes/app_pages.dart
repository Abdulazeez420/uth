import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uth_task/app/controllers/expense_controller.dart';
import 'package:uth_task/app/controllers/income_controller.dart';
import 'package:uth_task/app/controllers/savings_controller.dart';
import 'package:uth_task/app/views/expense/add_expense_page.dart';
import 'package:uth_task/app/views/home/home_page.dart';
import '../views/auth/login_page.dart';
import '../views/auth/signup_page.dart';
import '../views/income/add_income_page.dart';
import '../views/savings/add_savings_goal_page.dart';
import '../controllers/auth_controller.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

   static var  INITIAL = FirebaseAuth.instance.currentUser == null ? Routes.LOGIN : Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
       binding: BindingsBuilder(() {
        Get.put(IncomeController());
        Get.put(ExpenseController());
        Get.put(SavingsController());
      }),

    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginPage(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignUpPage(),
      binding: BindingsBuilder(() {
        Get.put(AuthController());
      }),
    ),
    GetPage(
      name: _Paths.ADD_INCOME,
      page: () => AddIncomePage(),
      binding: BindingsBuilder(() {
        Get.put(IncomeController());
      }),
    ),
    GetPage(
      name: _Paths.ADD_EXPENSE,
      page: () => AddExpensePage(),
        binding: BindingsBuilder(() {
        Get.put(ExpenseController());
      }),
    ),
    GetPage(
      name: _Paths.ADD_SAVINGS_GOAL,
      page: () => AddSavingsGoalPage(),
        binding: BindingsBuilder(() {
        Get.put(SavingsController());
      }),
    ),
  ];
}
