import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //get current user
  User? getCurrentUser(){
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailAndPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
        
        // save user info if it already didn't exist
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          'email':email
        }
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
       // throw the exception and the message together
      throw Exception('${e.code}: ${e.message}');
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailAndPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password
      );

      // save user info in different document
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {
          'uid':userCredential.user!.uid,
          'email':email
        }
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception('${e.code}: ${e.message}');
    }
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }
}