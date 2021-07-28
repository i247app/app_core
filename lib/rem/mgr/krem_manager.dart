import 'package:app_core/rem/krem.dart';

abstract class KREMManager {
  KREMAction? dispatch(String path, Map<String, dynamic> data);

  KREMPath processPath(String path) {
    KREMPath paths;
    try {
      List<String> tokens = path.split(".");
      paths = KREMPath(
        tokens[0],
        tokens.length > 1 ? (tokens.join(".")) : "",
      );
    } catch (e) {
      print(e.toString());
      paths = KREMPath("", "");
    }
    return paths;
  }
}
