import 'package:app_core/app_core.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class KLinkHelper {
  /// Open link
  static Future<bool> openLink(String urlString) async {
    bool boo = false;
    try {
      final url = Uri.parse(urlString);
      if ((await canLaunchUrl(url))) {
        return launchUrl(url);
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

    final urlString = "mailto:$email";
    bool boo = false;
    try {
      final url = Uri.parse(urlString);
      if ((await canLaunchUrl(url))) {
        return launchUrl(url);
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
      final urlString = "sms:$phoneNumber".trim();
      final url = Uri.parse(urlString);
      if ((await canLaunchUrl(url))) {
        boo = await launchUrl(url);
      }
    } catch (e) {}
    return boo ?? false;
  }

  /// Open the telephone app using this number
  static Future<bool> openPhone(String phoneNumber) async {
    bool? boo;
    try {
      //  TODO - clean up phone number +84 0909100050 will break
      final urlString = "tel:$phoneNumber".trim();
      final url = Uri.parse(urlString);
      if ((await canLaunchUrl(url))) {
        boo = await launchUrl(url);
      }
    } catch (e) {}
    return boo ?? false;
  }

  /// Open the maps app to view a search
  static Future<bool> openMap({String? address, KLatLng? latLng}) async {
    String urlString = "https://www.google.com/maps/search/?api=1&query=";
    if (latLng != null) {
      urlString += Uri.encodeFull(latLng.toString());
    } else if (address != null) {
      urlString += Uri.encodeFull(address);
    }

    final url = Uri.parse(urlString);
    print("LinkHelper.openMap URL - $url");
    return (await canLaunchUrl(url)) ? launchUrl(url) : Future.value(false);
  }

  /// Open the maps app for directions
  static Future<bool> openDirections({
    String? address,
    KLatLng? latLng,
  }) async {
    String urlString = "https://www.google.com/maps/dir/?api=1";
    if (latLng != null) {
      urlString += "&destination=${Uri.encodeFull(latLng.toString())}";
    } else if (address != null) {
      urlString += "&destination=${Uri.encodeFull(address)}";
    }

    final url = Uri.parse(urlString);
    print("LinkHelper.openDirections URL - $url");
    return (await canLaunchUrl(url)) ? launchUrl(url) : Future.value(false);
  }
}
