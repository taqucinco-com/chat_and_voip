// https://github.com/firebase/flutterfire/tree/master?tab=readme-ov-file

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myflutterapp/main.dart';

abstract interface class AuthorizationFacade {
  Future<UserCredential?> signInWithGoogle();
  Future<void> signOut();
  Future<String?> getIdToken();
  Future<void> deleteAccount();
}

class AuthorizationFacadeImpl implements AuthorizationFacade {
  @override
  Future<String?> getIdToken() async {
    try {
      // Get the current user.
      User? user = auth.currentUser;

      // Get the idToken of the user.
      if (user != null) {
        // user.displayName
        // user.photoURL
        String? idToken = await user.getIdToken();
        if (kDebugMode) print('User idToken successfully retrieved! $idToken');
        return idToken;
      } else {
        if (kDebugMode) print('No user is currently signed in.');
        return null;
      }
    } catch (e) {
      if (kDebugMode) print('Failed to get idToken: $e');
      return null;
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) print('Failed with error code: ${e.code}');
      if (kDebugMode) print(e.message);
      return null;
    } catch (e) {
      if (kDebugMode) print(e);
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    try {
      // Get the current user.
      User? user = FirebaseAuth.instance.currentUser;

      // Delete the user.
      if (user != null) {
        await user.delete();
        if (kDebugMode) print('User successfully deleted!');
      } else {
        if (kDebugMode) print('No user is currently signed in.');
      }
    } catch (e) {
      if (kDebugMode) print('Failed to delete user: $e');
    }
  }
}
