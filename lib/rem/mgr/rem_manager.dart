import 'package:app_core/rem/rem.dart';

abstract class AppCoreREMManager {
  AppCoreREMAction? dispatch(String path, Map<String, dynamic> data);

  AppCoreREMPath processPath(String path) {
    AppCoreREMPath paths;
    try {
      List<String> tokens = path.split(".");
      paths = AppCoreREMPath(
        tokens[0],
        tokens.length > 1 ? (tokens.join(".")) : "",
      );
    } catch (e) {
      print(e.toString());
      paths = AppCoreREMPath("", "");
    }
    return paths;
  }
}
