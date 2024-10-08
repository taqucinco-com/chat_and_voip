import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:myflutterapp/feature/advertise/advertiser.dart';

AsyncSnapshot<InterstitialAd> useFutureInterstitialAd(
  Advertiser advertiser,
) {
  final future = useMemoized(() => advertiser.loadInterstitialAd());
  final interstitialAd = useFuture(future);
  useEffect(() {
    return interstitialAd.data?.dispose;
  }, []);
  return interstitialAd;
}
