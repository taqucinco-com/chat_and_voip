import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract interface class Advertiser {
  Future<InterstitialAd> loadInterstitialAd();
}
