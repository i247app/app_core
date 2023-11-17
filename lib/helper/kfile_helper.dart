import 'dart:io';

import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract class KFileHelper {
  static Future<bool> downloadImageFromURL(String url) async =>
      await GallerySaver.saveImage(url) ?? false;

  static Future<File> downloadFileFromURL(String url) async {
    final documentDirectory = await (Platform.isAndroid
        ? getExternalStorageDirectory()
        : getApplicationDocumentsDirectory());
    final firstPath = documentDirectory!.path + "/images";
    final filePathAndName = firstPath + '/pic.jpg';
    //comment out the next three lines to prevent the image from being saved
    //to the device to show that it's coming from the internet
    await Directory(firstPath).create(recursive: true); // <-- 1

    final file = File(filePathAndName);

    final response = await http.get(Uri.parse(url));
    await file.writeAsBytes(response.bodyBytes);

    return file;
  }

  static String basename(String fullPath) {
    final fileName = (fullPath.split('/').last);
    // final filePath = fullPath.replaceAll("/$fileName", '');
    return fileName;
  }
}
