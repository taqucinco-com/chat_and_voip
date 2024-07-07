import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/firebase_options.dart';
import 'package:myflutterapp/my_app.dart';

late final FirebaseApp app;
late final FirebaseAuth auth;

bool shouldUseFirebaseEmulator = false;

Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    auth = FirebaseAuth.instanceFor(app: app);

    if (shouldUseFirebaseEmulator) {
      await auth.useAuthEmulator('localhost', 9099);
    }
    runApp(
      ProviderScope(
        child: MyApp(),
      ),
    );
  }, (error, stack) {
    if (kDebugMode) print(error);
  });
}
