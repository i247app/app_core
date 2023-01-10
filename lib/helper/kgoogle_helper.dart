import 'package:app_core/app_core.dart';
import 'package:app_core/helper/kgeo_helper.dart';
import 'package:app_core/helper/kserver_handler.dart';
import 'package:app_core/model/kaddress.dart';
import 'package:app_core/value/kconstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_maps_webservice/geocoding.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

/// Helpful links for tracking API usage and cost
/// Places: https://developers.google.com/places/web-service/usage-and-billing
/// Geocoding: https://developers.google.com/maps/documentation/geocoding/usage-and-billing
abstract class KGoogleHelper {
  static Location hcmcLocation = Location(lat: 10.762963, lng: 106.682383);
  static Location hanoiCity = Location(lat: 21.027764, lng: 105.834160);
  static Location sanfracisco = Location(lat: 37.7749, lng: -122.4194);

  static const String API_HIT_COUNT_PREF_KEY = "_google_api_hit_count";
  static const String CACHED_PLACE_HIT_COUNT_PREF_KEY =
      "_cached_place_hit_count";
  static const String CACHED_GEO_HIT_COUNT_PREF_KEY =
      "_cached_geo_location_hit_count";
  static const String CACHED_ADDRESS = "cached_address";

  static bool get isEnable => KSessionData.appNav?.googleAppMode == KAppNav.ON;

  static final GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: KConstants.googleMapsApiKey);

  static final GoogleMapsGeocoding _geocoding =
      GoogleMapsGeocoding(apiKey: KConstants.googleMapsApiKey);

  static int gcnt = 0;

  /// Lookup placeID
  static Future<PlaceDetails?> lookupPlaceID(String placeID,
      {bool geoOnly = true}) async {
    if (!isEnable) {
      return null;
    }
    print("[${gcnt++}] google_helper.lookupPlaceID getDetailsByPlaceId");
    final placedetailsString = await KPrefHelper.get(placeID);

    if (placedetailsString != null) {
      _logCachedAPIHit(CACHED_PLACE_HIT_COUNT_PREF_KEY);
      return PlaceDetails.fromJson(placedetailsString);
    }
    var fields = <String>[];
    if (geoOnly) {
      fields = ["name", "place_id", "geometry/location"];
    } else {
      fields = ["geometry/location", "name", "place_id", "formatted_address"];
    }

    try {
      PlaceDetails placeDetails = await _places
          .getDetailsByPlaceId(placeID, fields: fields)
          .then((r) => r.result);
      _logAPIHit();
      await KPrefHelper.put(placeID, placeDetails);
      return placeDetails;
    } catch (ex) {
      KServerHandler.echoGoogleCrash("lookupPlaceID: ${ex.toString()}");
    }

    return null;
  }

  /// Geocode a lat lng
  static Future<List<GeocodingResult>> lookupLatLng(KLatLng latLng) async {
    if (!isEnable) {
      return [];
    }
    print("[${gcnt++}] geo_helper.lookupLatLng searchByLocation");

    try {
      final response = await _geocoding.searchByLocation(latLng.toLocation());
      _logAPIHit();
      for (GeocodingResult gr in response.results) print(gr.formattedAddress);
      return response.results;
    } catch (ex) {
      KServerHandler.echoGoogleCrash("lookupLatLng: ${ex.toString()}");
    }

    return [];
  }

  /// Geocode a lat lng
  static Future<List<GeocodingResult>> lookupLatLng2(KLatLng latLng) async {
    final addressCachedString = await KPrefHelper.get(CACHED_ADDRESS);
    if (addressCachedString != null) {
      final geoObject = GeocodingResponse.fromJson(addressCachedString);
      final List<GeocodingResult> listGeoCoding = [];
      for (var address in geoObject.results) {
        final latlng2 = KLatLng.fromLocation(address.geometry.location);
        final double distance =
            KLocationHelper.calculateDistance(latLng, latlng2);
        if (distance < 50) {
          listGeoCoding.add(address);
        }
      }
      if (listGeoCoding.length > 0) {
        _logCachedAPIHit(CACHED_GEO_HIT_COUNT_PREF_KEY);
        return listGeoCoding;
      }
    }

    if (!isEnable) {
      return [];
    }

    print("[${gcnt++}] geo_helper.lookupLatLng searchByLocation");

    try {
      final response = await _geocoding.searchByLocation(latLng.toLocation());
      _logAPIHit();
      for (GeocodingResult gr in response.results) print(gr.formattedAddress);
      // Save result to Preferences
      if (addressCachedString != null) {
        final geoObject = GeocodingResponse.fromJson(addressCachedString);
        final saveObject = GeocodingResponse(
            results: [...geoObject.results, ...response.results],
            status: "",
            errorMessage: "");
        await KPrefHelper.put(CACHED_ADDRESS, saveObject.toJson());
      } else {
        await KPrefHelper.put(CACHED_ADDRESS, response.toJson());
      }

      return response.results;
    } catch (ex) {
      KServerHandler.echoGoogleCrash("lookupLatLng2: ${ex.toString()}");
    }

    return [];
  }

  /// Geocode an address
  static Future<GeocodingResult?> lookupAddress(String address) async {
    if (!isEnable) {
      return null;
    }
    print("[${gcnt++}] geo_helper.lookupAddress searchByAddress");

    try {
      List<GeocodingResult> results =
          await _geocoding.searchByAddress(address).then((r) => r.results);
      _logAPIHit();
      return results.isEmpty ? null : results.first;
    } catch (ex) {
      KServerHandler.echoGoogleCrash("lookupAddress: ${ex.toString()}");
    }

    return null;
  }

  /// Get direction lines
  static Future<DirectionsResponse?> getDirectionLines(
    String origin,
    String address,
  ) async {
    if (!isEnable) {
      return null;
    }
    final DirectionsResponse response =
        await GoogleMapsDirections(apiKey: KConstants.googleMapsApiKey)
            .directions(origin, address);
    return response;
  }

  /// Open place autocomplete and return the details
  static Future<KAddress?> showPlaceLookupKAddress(BuildContext ctx,
      {KLatLng? deviceLocation}) async {
    if (!isEnable) {
      return null;
    }
    print("[${gcnt++}] geo_helper.showPlaceLookup PlacesAutocomplete");
    try {
      final position = KLocationHelper.cachedPosition;
      final location = deviceLocation != null
          ? Location(lat: deviceLocation.lat!, lng: deviceLocation.lng!)
          : position != null
              ? Location(lat: position.latitude, lng: position.latitude)
              : hcmcLocation;
      Prediction? p = await PlacesAutocomplete.show(
        context: ctx,
        apiKey: KConstants.googleMapsApiKey,
        logo: Image.asset(
          KAssets.IMG_TRANSPARENCY,
          package: 'app_core',
        ),
        mode: Mode.overlay,
        offset: 0,
        location: location,
        radius: 1000,
        types: [],
        strictbounds: false,
        components: [],
        onError: (PlacesAutocompleteResponse? r) => print(
            "GeoHelper.showPlaceLookup ERROR - ${KUtil.prettyJSON(r?.toJson())}"),
      );
      _logAPIHit();
      if (p != null) {
        final placeDetail = await KGoogleHelper.lookupPlaceID(p.placeId!);
        return KGeoHelper.getKAddressPrediction(p, placeDetail);
      }
    } catch (e) {
      KServerHandler.echoGoogleCrash(
          "showPlaceLookupKAddress: ${e.toString()}");
      print("GeoHelper.showPlaceLookup ERROR - $e");
    }
    return null;
  }

  static void _logAPIHit() => KPrefHelper.get<int>(API_HIT_COUNT_PREF_KEY).then(
        (value) => KPrefHelper.put(
          API_HIT_COUNT_PREF_KEY,
          (value ?? 0) + 1,
        ),
      );

  static void _logCachedAPIHit(String key) => KPrefHelper.get<int>(key).then(
        (value) => KPrefHelper.put(
          key,
          (value ?? 0) + 1,
        ),
      );
}
