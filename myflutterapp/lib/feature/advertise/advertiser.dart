import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract interface class Advertiser {
  Future<InterstitialAd> loadInterstitialAd();
  Future<bool> sendTriggerEvent(AdvertiseTriggerEvent event);
}

/*
 * 広告表示の引き金となりうるイベント
 */
sealed class AdvertiseTriggerEvent {}

class AdvertiseTriggerEventQuestion extends AdvertiseTriggerEvent {}
