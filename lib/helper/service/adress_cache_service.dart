import 'package:app_core/app_core.dart';
import 'package:app_core/model/kgig_address.dart';

abstract class KAddressCacheService {
  static const double PROXIMITY = 30;

  static final List<KGigAddress> _cachedAddresses = [];

  static bool isWithinProximity(KLatLng ll1, KLatLng ll2,
          {double proximity = PROXIMITY}) =>
      KLocationHelper.calculateDistance(ll1, ll2) <= proximity;

  static void addToCache(KGigAddress address) {
    if (address.latLng == null) {
      print("# # # CACHED ADDRESSES NEED A LAT LNG - not caching this one");
      return;
    }

    // Attempt to replace an existing cached address based on proximity
    for (int i = 0; i < _cachedAddresses.length; i++) {
      final cachedAddr = _cachedAddresses[i];
      if (isWithinProximity(address.latLng!, cachedAddr.latLng!)) {
        _cachedAddresses[i] = address;
        return;
      }
    }

    // Otherwise just add it
    _cachedAddresses.add(address);
  }

  static KGigAddress? getCurrentAddress(KLatLng latLng) {
    for (int i = 0; i < _cachedAddresses.length; i++) {
      final cachedAddr = _cachedAddresses[i];
      final dist =
          KLocationHelper.calculateDistance(latLng, cachedAddr.latLng!);
      print("AddressCacheService == CACHED ADDR [$i] proximity is $dist");
      if (dist <= PROXIMITY) {
        return cachedAddr;
      }
    }
    return null;
  }
}
