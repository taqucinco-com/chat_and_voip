https://firebase.google.com/docs/flutter/setup?hl=ja&_gl=1*1dnjob9*_up*MQ..*_ga*MTg2MTMzNDU4LjE3MTI0OTI4Nzc.*_ga_CW55HF8NVT*MTcxMjQ5Mjg3Ny4xLjAuMTcxMjQ5Mjg3Ny4wLjAuMA..&platform=ios

// https://firebase.google.com/docs/auth/flutter/errors?hl=ja&_gl=1*1lpanqz*_up*MQ..*_ga*MTQyMzY1MTIwNi4xNzEyNjU3NjMw*_ga_CW55HF8NVT*MTcxMjY1NzYyOS4xLjAuMTcxMjY1NzYyOS4wLjAuMA..

https://pub.dev/packages/firebase_auth

```
npm install -g firebase-tools
$ firebase login
$ dart pub global activate flutterfire_cli
    // export PATH="$PATH":"$HOME/.pub-cache/bin" を実行する必要がある旨の警告が出る場合がある
$ flutterfire configure
```

- DefaultFirebaseOptionsがlibフォルダ直下に作られる
- /ios, /androidなどのフォルダ内にFirebase関連の設定ファイルが作られる。
- open ios/Runner.xcworkspaceを起動して `プロジェクト > TARGET > Runner > Info > URL Types > URL SchemesにREVERSED_CLIENT_IDを入れる

https://github.com/firebase/flutterfire/blob/master/packages/firebase_auth/firebase_auth/example/lib/main.dart
のコードで初期化する。

```main.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth.dart';
import 'firebase_options.dart';
import 'profile.dart';

/// Requires that a Firebase local emulator is running locally.
/// See https://firebase.flutter.dev/docs/auth/start/#optional-prototype-and-test-with-firebase-local-emulator-suite
bool shouldUseFirebaseEmulator = false;

late final FirebaseApp app;
late final FirebaseAuth auth;

// Requires that the Firebase Auth emulator is running locally
// e.g via `melos run firebase:emulator`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We're using the manual installation on non-web platforms since Google sign in plugin doesn't yet support Dart initialization.
  // See related issue: https://github.com/flutter/flutter/issues/96391

  // We store the app and auth to make testing with a named instance easier.
  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  auth = FirebaseAuth.instanceFor(app: app);

  if (shouldUseFirebaseEmulator) {
    await auth.useAuthEmulator('localhost', 9099);
  }

  if (!kIsWeb && Platform.isWindows) {
    await GoogleSignInDart.register(
      clientId:
          '406099696497-g5o9l0blii9970bgmfcfv14pioj90djd.apps.googleusercontent.com',
    );
  }

  runApp(const AuthExampleApp());
}
```

+web対応を行う場合は以下のリンクを参考にする。

https://pub.dev/packages/google_sign_in_web#web-integration