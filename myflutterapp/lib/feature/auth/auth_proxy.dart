// https://github.com/firebase/flutterfire/tree/master?tab=readme-ov-file

// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/main.dart';

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  return auth.authStateChanges();
});

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
    print('Failed with error code: ${e.code}');
    print(e.message);
    return null;
  } catch (e) {
    print(e);
    rethrow;
  }
}

Future<void> signOut() async {
  auth.signOut();
}

Future<void> deleteAccount() async {
  try {
    // Get the current user.
    User? user = FirebaseAuth.instance.currentUser;

    // Delete the user.
    if (user != null) {
      await user.delete();
      print('User successfully deleted!');
    } else {
      print('No user is currently signed in.');
    }
  } catch (e) {
    print('Failed to delete user: $e');
  }
}

Future<String?> getIdToken() async {
  try {
    // Get the current user.
    User? user = auth.currentUser;
    // Get the idToken of the user.
    if (user != null) {
      String? idToken = await user.getIdToken();
      print('User idToken successfully retrieved! $idToken');
      return idToken;
    } else {
      print('No user is currently signed in.');
      return null;
    }
  } catch (e) {
    print('Failed to get idToken: $e');
    return null;
  }
}