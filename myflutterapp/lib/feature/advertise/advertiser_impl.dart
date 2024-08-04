import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myflutterapp/feature/advertise/admob/ad_mob_helper.dart';
import 'package:myflutterapp/feature/advertise/advertiser.dart';

class AdvertiserImpl implements Advertiser {
  final AdMobHelper _adMobHelper;
  const AdvertiserImpl({adMobHelper}) : _adMobHelper = adMobHelper;

  @override
  Future<InterstitialAd> loadInterstitialAd() async {
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
}
