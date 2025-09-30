import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _cnicToEmail(String cnic) {
    // Remove dashes
    String cleaned = cnic.replaceAll('-', '').trim();
    return '$cleaned@cnic.app';
  }

  Future<Map<String, dynamic>?> loginWithCnic({
    required String cnic,
    required String password,
  }) async {
    try {
      String email = _cnicToEmail(cnic);
      print('Trying login with email: $email');

      UserCredential uc = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = uc.user!.uid;
      print('Login success. UID = $uid');

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (!userDoc.exists) {
        print('User data not found in Firestore.');
        return null;
      }
      Map<String, dynamic>? data = userDoc.data() as Map<String, dynamic>?;
      print('Fetched user data: $data');
      return data;
    } on FirebaseAuthException catch (e) {
      print('Auth error: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      print('Other error: $e');
      return null;
    }
  }
}
