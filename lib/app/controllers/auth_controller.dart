import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:uth_task/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Rx<User?> _firebaseUser;
  final GetStorage box = GetStorage();
  final RxBool loading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool obscureText = true.obs;


  final TextEditingController confirmPasswordController = TextEditingController();
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    ever(_firebaseUser, _setInitialScreen);
    clearControllers();
  }

  User? get user => _firebaseUser.value;

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  Future<void> signIn(String email, String password) async {
    loading.value = true;
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
         box.write("uid", user.uid);
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'uid': user.uid,
            'lastSignIn': FieldValue.serverTimestamp(),
          });
        } else {
          await _firestore.collection('users').doc(user.uid).update({
            'lastSignIn': FieldValue.serverTimestamp(),
          });
        }
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? 'An error occurred');
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

  Future<void> signUp(String email, String password, String confirmPassword) async {
    loading.value = true;
    if (password != confirmPassword) {
      Get.snackbar("Error", 'Passwords do not match');
      loading.value = false;
      return;
    }
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        box.write("uid", user.uid);
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'uid': user.uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
        Get.snackbar("Success", 'Account created successfully');
        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", 'Email ID already exists');
      } else {
        Get.snackbar("Error", e.message ?? 'An error occurred');
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      loading.value = false;
    }
  }

Future<void> signOut() async {
  try {
    
    box.erase(); 
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    await _auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
    
    // Optionally restart the app or refresh other states as needed
  } catch (e) {
    Get.snackbar("Error", e.toString());
  }
}


}
