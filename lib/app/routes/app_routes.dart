part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const ADD_INCOME = _Paths.ADD_INCOME;
  static const ADD_EXPENSE = _Paths.ADD_EXPENSE;
  static const ADD_SAVINGS_GOAL = _Paths.ADD_SAVINGS_GOAL;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const ADD_INCOME = '/add-income';
  static const ADD_EXPENSE ='/add-expense';
  static const ADD_SAVINGS_GOAL = '/add-savings-goal';
}
