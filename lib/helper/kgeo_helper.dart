import 'dart:io';

import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kgoogle_helper.dart';
import 'package:app_core/model/kaddress.dart';
import 'package:app_core/model/kgig_address.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';

/// Helpful links for tracking API usage and cost
/// Places: https://developers.google.com/places/web-service/usage-and-billing
/// Geocoding: https://developers.google.com/maps/documentation/geocoding/usage-and-billing
abstract class KGeoHelper {
  static const String API_HIT_COUNT_PREF_KEY = "_google_api_hit_count";

  static int gcnt = 0;

  static const List<String> CITY_ADDR_COMP_TYPES = [
    "administrative_area_level_1"
  ];

  static Future<void> openExternalMap(
      BuildContext context, double lat, double lng,
      {double? slat, double? slng}) async {
    String url = '';
    String urlAppleMaps = '';
    if (Platform.isAndroid) {
      url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    } else {
      urlAppleMaps = 'https://maps.apple.com/?q=$lat,$lng';
      if (slat != null && slng != null) {
        url =
            'comgooglemaps://?saddr=$slat,$slng&daddr=$lat,$lng&directionsmode=driving';
      } else {
        url = 'comgooglemaps://?saddr=&daddr=$lat,$lng&directionsmode=driving';
      }

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    if (await canLaunch(url)) {
      await launch(url);
    } else if (await canLaunch(urlAppleMaps)) {
      await launch(urlAppleMaps);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Decode the google encoded string using Encoded Polyline Algorithm Format
  /// for more info about the algorithm check https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  ///
  ///return [List]
  static List<LatLng> decodeEncodedPolyline(String encoded) {
    List<LatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      LatLng p = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  static String getCountryCode(PlaceDetails placeDetails) =>
      getAddressComponent(placeDetails, "country") ?? KLocaleHelper.COUNTRY_US;

  static KAddress getAddress(PlaceDetails place) {
    // debugPrint("PLACE: ${KUtil.prettyJSON(place.toJson())}", wrapWidth: 10000);

    String address1 = "";
    String? streetAddress;
    String? extendedAddress;
    String? locality;
    String? region;
    String? postalCode;

    final address = KAddress();
    address.placeID = place.placeId;
    address.fullAddressLine = place.formattedAddress;
    address.name = place.name;

    for (AddressComponent component in place.addressComponents) {
      final componentType = component.types.first;

      switch (componentType) {
        case "street_number":
          address1 = "${component.longName} $address1";
          break;
        case "street_number":
          address1 = "${component.longName} $address1";
          break;
        case "route":
          address1 += component.longName;
          break;
        case "postal_code":
          address.zipCode = component.longName;
          break;
        case "country":
          address.countryCode = component.shortName.toLowerCase();
          break;
      }
    }

    if (KStringHelper.isExist(place.adrAddress)) {
      final adrAddress = parse(place.adrAddress);
      streetAddress = adrAddress.querySelector('.street-address')?.text;
      extendedAddress = adrAddress.querySelector('.extended-address')?.text;
      locality = adrAddress.querySelector('.locality')?.text;
      region = adrAddress.querySelector('.region')?.text;
      postalCode = adrAddress.querySelector('.postal-code')?.text;
    }

    address.addressLine1 = streetAddress ?? address1;
    if (address.countryCode == KLocaleHelper.COUNTRY_US) {
      address.city = locality;
      address.state = region;
      address.zipCode = postalCode ?? address.zipCode;
    } else {
      address.ward = extendedAddress;
      address.district = locality;
      address.city = region;
    }

    address.district = KUtil.removeIgnoreStrings(
        address.district ?? "", KUtil.ignoreAddressWords);
    address.ward =
        KUtil.removeIgnoreStrings(address.ward ?? "", KUtil.ignoreAddressWords);

    if (place.geometry?.location != null) {
      address.latLng = KLatLng.fromLocation(place.geometry!.location);
    }
    return address;
  }

  static KAddress getKAddressPrediction(
      Prediction place, PlaceDetails? placeDetails) {
    // debugPrint("PLACE: ${KUtil.prettyJSON(place.toJson())}", wrapWidth: 10000);

    final address = KAddress();
    address.placeID = place.placeId;
    address.fullAddressLine = place.description;
    address.name = place.structuredFormatting?.mainText;
    address.addressLine1 = place.structuredFormatting?.mainText;
    final terms = place.terms;
    final termsCount = terms.length;
    address.ward = termsCount >= 4 ? terms[termsCount - 4].value : null;
    address.district = termsCount >= 3 ? terms[termsCount - 3].value : null;
    final city = termsCount >= 2 ? terms[termsCount - 2].value : "";
    final country = termsCount >= 1 ? terms[termsCount - 1].value : "";
    address.district = KUtil.removeIgnoreStrings(
        address.district ?? "", KUtil.ignoreAddressWords);
    address.ward =
        KUtil.removeIgnoreStrings(address.ward ?? "", KUtil.ignoreAddressWords);

    // Get first character of each word in city string
    final shortCityName =
        city.split(" ").map((word) => word[0]).join().toUpperCase();
    if (shortCityName == "HCMC") {
      address.city = shortCityName;
    } else {
      address.city = city;
    }
    if (country.contains("Vietnam")) {
      address.countryCode = KLocaleHelper.COUNTRY_VN;
    } else {
      address.countryCode = KLocaleHelper.COUNTRY_US;
    }
    if (placeDetails != null && placeDetails.geometry != null) {
      address.latLng = KLatLng.fromLocation(placeDetails.geometry!.location);
    }

    return address;
  }

  static KGigAddress? geocodingToGigAddress(GeocodingResult place) {
    // debugPrint("PLACE: ${KUtil.prettyJSON(place.toJson())}", wrapWidth: 10000);

    try {
      final address = KGigAddress();
      address.placeID = place.placeId;
      address.fullAddressLine = place.formattedAddress;

      final components = (place.formattedAddress ?? "").split(", ");

      // Last address component is country
      final country = components.last;
      address.countryCode = country == 'Vietnam'
          ? KLocaleHelper.COUNTRY_VN
          : KLocaleHelper.COUNTRY_US;
      if (components.length >= 3) {
        // last - 1 is city
        final city = components[components.length - 2];
        // Get first character of each word in city string
        final shortCityName =
            city.split(" ").map((word) => word[0]).join().toUpperCase();
        address.city = shortCityName == "HCMC" ? shortCityName : city;
      }
      if (components.length >= 4) {
        // last - 2 is district
        final district = components[components.length - 3];
        address.district =
            KUtil.removeIgnoreStrings(district, KUtil.ignoreAddressWords);
      }
      if (components.length >= 5) {
        // last - 3 is ward
        final ward = components[components.length - 4];
        address.ward = ward;
      }
      address.ward = KUtil.removeIgnoreStrings(
          address.ward ?? "", KUtil.ignoreAddressWords);
      address.addressLine1 = components.first;
      address.name = components.first;
      address.latLng = KLatLng.fromLocation(place.geometry.location);

      return address;
    } catch (ex) {
      print("geocodingToGigAddress: ${ex}");
    }
    return null;
  }

  static Future<List<KGigAddress>?> getGigAddressesFromLatLng(
      KLatLng latLng) async {
    try {
      print("[${gcnt}] geo_helper.getGigAddressesFromLatLng");

      final List<GeocodingResult> results = await KGoogleHelper.lookupLatLng2(
          KLatLng.raw(latLng.lat!, latLng.lng!));
      // debugPrint("PLACE: ${result.results[0].toJson()}", wrapWidth: 10000);

      if (results.isNotEmpty) {
        final List<KGigAddress> addresses = [];

        for (int i = 0; i < results.length; i++) {
          print("[${gcnt}] geo_helper.getGigAddressesFromLatLng lookupPlaceID");

          final GeocodingResult geocodingResult = results[i];
          final KGigAddress? address = geocodingToGigAddress(geocodingResult);
          print("address: ${address}");
          if (address != null && addresses.length < 2) {
            addresses.add(address);
          }
        }

        return addresses;
      }
    } catch (e) {
      print("geo_helper.getGigAddressesFromLatLng lookupPlaceID: ${e}");
    }
    return null;
  }

  static String? getAddressComponent(PlaceDetails placeDetails, String type) {
    for (AddressComponent addressComponent in placeDetails.addressComponents) {
      for (String t in addressComponent.types) {
        if (t == type) return addressComponent.shortName.toLowerCase();
      }
    }
    return null;
  }
}
