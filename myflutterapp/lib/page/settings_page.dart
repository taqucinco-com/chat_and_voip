// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/main.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: user.value != null
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Logged in as: ${user.value?.email}'),
                ElevatedButton(
                onPressed: _signOut,
                child: const Text('Logout'),
                ),
                ElevatedButton(
                onPressed: _deleteAccount,
                child: const Text('Delete Account'),
                ),
              ],
              )
            : ElevatedButton(
                onPressed: _signInWithGoogle,
                child: const Text('Login'),
              ),
      ),
    );
  }

  Future<UserCredential?> _signInWithGoogle() async {
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

  Future<void> _signOut() async {
    auth.signOut();
  }

  Future<void> _deleteAccount() async {
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
}

final authStateChangesProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
