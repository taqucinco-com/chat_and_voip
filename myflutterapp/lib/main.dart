import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/driver/db/hive_box.dart';
import 'package:myflutterapp/feature/advertise/admob/admob_helper_provider.dart';
import 'package:myflutterapp/feature/advertise/admob/test_ad_mob_helper.dart';
import 'package:myflutterapp/feature/message/gateway/message_dao.dart';
import 'package:myflutterapp/feature/message/gateway/message_repository.dart';
import 'package:myflutterapp/firebase_options.dart';
import 'package:myflutterapp/my_app.dart';
import 'package:path_provider/path_provider.dart';

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

    final dir = await getApplicationDocumentsDirectory();
    Hive
      ..init(dir.path)
      ..registerAdapter(MessageDaoAdapter());

    final messageBox = await Hive.openBox(messageDaoBoxName);

    await MobileAds.instance.initialize();

    if (shouldUseFirebaseEmulator) {
      await auth.useAuthEmulator('localhost', 9099);
    }
    runApp(
      ProviderScope(
        overrides: [
          messageBoxProvider.overrideWith((ref) {
            ref.onDispose(() async => await messageBox.close());
            return messageBox;
          }),
          adMobHelperProvider.overrideWith(
            (_) => TestAdMobHelper(),
          ),
        ],
        child: MyApp(),
      ),
    );
  }, (error, stack) {
    if (kDebugMode) print(error);
  });
}
