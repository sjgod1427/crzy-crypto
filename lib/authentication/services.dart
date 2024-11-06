import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String>? signUpUser(
      {required String email,
      required String username,
      required String password}) async {
    String res = "Some error occured";
    try {
      if (username.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        UserCredential credential = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);
        await _firebaseFirestore
            .collection("users")
            .doc(credential.user!.uid)
            .set({
          "username": username,
          "email": email,
          "uid": credential.user!.uid
        });
        res = "Successfull";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //login user with email and password
        await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "sucess";
      } else {
        res = "Please enter all field";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
