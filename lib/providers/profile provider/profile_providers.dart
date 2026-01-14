import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool loading = false;

  AuthProvider() {
    _auth.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = cred.user;
    } on FirebaseAuthException {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      loading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        loading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _auth.signInWithCredential(credential);
      user = userCredential.user;
    } catch (e) {
      rethrow;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    user = null;
    notifyListeners();
  }
}
