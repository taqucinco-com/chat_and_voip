import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:myflutterapp/feature/advertise/admob/ad_mob_helper.dart';
import 'package:myflutterapp/feature/advertise/advertiser.dart';

const advertiseTriggerBox = "advertise_trigger_box";

class AdvertiserImpl implements Advertiser {
  final AdMobHelper _adMobHelper;
  const AdvertiserImpl({adMobHelper}) : _adMobHelper = adMobHelper;

  @override
  Future<InterstitialAd> loadInterstitialAd() async {
    print("loadInterstitialAd");
    final completer = Completer<InterstitialAd>();

    InterstitialAd.load(
      adUnitId: _adMobHelper.interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
        if (!completer.isCompleted) completer.complete(ad);
      }, onAdFailedToLoad: (error) {
        if (!completer.isCompleted) completer.completeError(error);
      }),
    );
    return completer.future;
  }

  @override
  Future<bool> sendTriggerEvent(AdvertiseTriggerEvent event) async {
    final box =
        await Hive.openBox<({DateTime date, int number})?>(advertiseTriggerBox);
    final count = box.get("count", defaultValue: null);

    if (count == null) {
      box.put("count", (date: DateTime.now(), number: 1));
    } else {
      final (:date, :number) = count;
      if (date.difference(DateTime.now()).inDays > 1) {
        box.put("count", (date: DateTime.now(), number: 1));
      } else {
        box.put("count", (date: date, number: number + 1));
        return switch (number + 1) {
          3 || 5 || 10 => true,
          _ => false,
        };
      }
    }
    return false;
  }
}
