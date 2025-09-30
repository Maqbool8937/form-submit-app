import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthControllers extends GetxController {
  FirebaseAuth firebaseInstance = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  var isPasswordVisible = false.obs;

  var isChecked = false.obs;
  RxBool isLoading = false.obs;

  void toggleChecked() {
    isChecked.value = !isChecked.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<bool> signUpwithEmailandPassword({
    required String email,
    required String password,
    required String
    collectionName, // 'admins' or 'shortfilers' or any role‐based collection
    required String fullName,
    required String cnic,
    required String phoneNumber,
    required String region,
    required String district,
    required String post,
    required String role,
    required String username,
  }) async {
    try {
      isLoading.value = true;

      // 1. Create user with Firebase Authentication
      UserCredential userCredential = await firebaseInstance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 2. Extract UID from newly created user
      String uid = userCredential.user!.uid;

      // 3. Store user details in role-specific collection
      await fireStore.collection(collectionName).doc(uid).set({
        'uid': uid,
        'fullName': fullName,
        'cnic': cnic,
        'phoneNumber': phoneNumber,
        'email': email,
        'region': region,
        'district': district,
        'post': post,
        'role': role,
        'username': username,
        'userCreated': DateTime.now(),
      });

      // 4. Also store in centralized whitelist collection
      await fireStore.collection('whitelisted_users').doc(uid).set({
        'uid': uid,
        'fullName': fullName,
        'cnic': cnic,
        'phoneNumber': phoneNumber,
        'email': email,
        'region': region,
        'district': district,
        'post': post,
        'role': role,
        'username': username,
        'allowed': true,
        'createdAt': DateTime.now(),
      });

      isLoading.value = false;
      return true;
    } on FirebaseAuthException catch (e) {
      // More detailed error info
      print('FirebaseAuthException – code: ${e.code}, message: ${e.message}');
      isLoading.value = false;
      return false;
    } catch (e) {
      // Fallback
      print('Signup Error: $e');
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      // 1. Sign in the user
      UserCredential userCredential = await firebaseInstance
          .signInWithEmailAndPassword(email: email, password: password);

      String uid = userCredential.user!.uid;

      // 2. Check whitelist status from Firestore
      DocumentSnapshot<Map<String, dynamic>> snapshot = await fireStore
          .collection('whitelisted_users')
          .doc(uid)
          .get();

      if (!snapshot.exists) {
        // Not whitelisted
        isLoading.value = false;
        Get.snackbar('Access Denied', 'You are not whitelisted for this app.');
        await firebaseInstance.signOut(); // Sign them out immediately
        return false;
      }

      final data = snapshot.data();
      final isAllowed = data?['allowed'] ?? false;

      if (!isAllowed) {
        isLoading.value = false;
        Get.snackbar('Access Blocked', 'Your access is disabled by admin.');
        await firebaseInstance.signOut(); // Sign them out immediately
        return false;
      }

      // ✅ Login successful and user is allowed
      isLoading.value = false;
      return true;
    } catch (e) {
      print('Login Error: $e');
      isLoading.value = false;

      // Optional: You can parse error type here
      Get.snackbar('Login Failed', 'Invalid email or password');
      return false;
    }
  }
}
