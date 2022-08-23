import 'package:app_core/app_core.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class KLinkHelper {
  /// Open link
  static Future<bool> openLink(String url) async {
    bool boo = false;
    try {
      if ((await canLaunch(url))) {
        return launch(url);
      } else {
        return false;
      }
    } catch (e) {
      boo = false;
    }
    return boo;
  }

  /// Open Email
  static Future<bool> openEmail(String email) async {
    if (!KStringHelper.isEmail(email)) return false;

    final url = "mailto:$email";
    bool boo = false;
    try {
      if ((await canLaunch(url))) {
        return launch(url);
      } else {
        return false;
      }
    } catch (e) {
      boo = false;
    }
    return boo;
  }

  /// Open the sms app using this number
  static Future<bool> openSMS(String phoneNumber) async {
    bool? boo;
    try {
      //  TODO - clean up phone number +84 0909100050 will break
      final url = "sms:$phoneNumber".trim();
      if (await canLaunch(url)) boo = await launch(url);
    } catch (e) {}
    return boo ?? false;
  }

  /// Open the telephone app using this number
  static Future<bool> openPhone(String phoneNumber) async {
    bool? boo;
    try {
      //  TODO - clean up phone number +84 0909100050 will break
      final url = "tel:$phoneNumber".trim();
      if (await canLaunch(url)) boo = await launch(url);
    } catch (e) {}
    return boo ?? false;
  }

  /// Open the maps app to view a search
  static Future<bool> openMap({String? address, KLatLng? latLng}) async {
    String url = "https://www.google.com/maps/search/?api=1&query=";
    if (latLng != null)
      url += Uri.encodeFull(latLng.toString());
    else if (address != null) url += Uri.encodeFull(address);

    print("LinkHelper.openMap URL - $url");
    return (await canLaunch(url)) ? launch(url) : Future.value(false);
  }

  /// Open the maps app for directions
  static Future<bool> openDirections({
    String? address,
    KLatLng? latLng,
  }) async {
    String url = "https://www.google.com/maps/dir/?api=1";
    if (latLng != null)
      url += "&destination=${Uri.encodeFull(latLng.toString())}";
    else if (address != null) url += "&destination=${Uri.encodeFull(address)}";

    print("LinkHelper.openDirections URL - $url");
    return (await canLaunch(url)) ? launch(url) : Future.value(false);
  }
}
