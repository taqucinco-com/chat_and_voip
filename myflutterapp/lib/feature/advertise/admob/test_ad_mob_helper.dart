import 'dart:io';
import 'package:myflutterapp/feature/advertise/admob/ad_mob_helper.dart';

// https://codelabs.developers.google.com/codelabs/admob-ads-in-flutter?hl=ja#2
class TestAdMobHelper implements AdMobHelper {
  @override
  AdMobIdType get adMobId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544~3347511713";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~1458002511";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  AdMobIdType get bannerId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  AdMobIdType get interstitialId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  @override
  AdMobIdType get rewardId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
