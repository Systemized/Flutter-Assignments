import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  Future<UserCredential?> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userModel = UserModel(
          uid: userCredential.user!.uid,
          firstName: firstName,
          lastName: lastName,
          role: role,
          registrationDateTime: DateTime.now(),
          email: email,
        );

        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(userModel.toMap());
      }

      return userCredential;
    } catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }

  Future<void> updateUserData(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toMap());
    } catch (e) {
      print('Error updating user data: $e');
      rethrow;
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      await currentUser?.updateEmail(newEmail);
      if (currentUser != null) {
        await _firestore
            .collection('users')
            .doc(currentUser!.uid)
            .update({'email': newEmail});
      }
    } catch (e) {
      print('Error updating email: $e');
      rethrow;
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      await currentUser?.updatePassword(newPassword);
    } catch (e) {
      print('Error updating password: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      rethrow;
    }
  }
}

