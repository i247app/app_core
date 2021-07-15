import 'package:app_core/rem/rem.dart';

abstract class REMManager {
  REMAction? dispatch(String path, Map<String, dynamic> data);

  REMPath processPath(String path) {
    REMPath paths;
    try {
      List<String> tokens = path.split(".");
      paths = REMPath(
        tokens[0],
        tokens.length > 1 ? (tokens.join(".")) : "",
      );
    } catch (e) {
      print(e.toString());
      paths = REMPath("", "");
    }
    return paths;
  }
}
