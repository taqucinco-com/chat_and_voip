import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myflutterapp/feature/advertise/admob/admob_helper_provider.dart';
import 'package:myflutterapp/feature/advertise/advertiser.dart';
import 'package:myflutterapp/feature/advertise/advertiser_impl.dart';

final advertiserProvider = Provider.autoDispose<Advertiser>((ref) {
  final helper = ref.watch(adMobHelperProvider);
  return AdvertiserImpl(adMobHelper: helper);
});
