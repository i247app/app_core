import 'package:app_core/app_core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final phone1 = "65021364764";
  test("$phone1 should be a phone", () {
    expect(
      phone1,
      allOf(
        [KStringHelper.isPhone(phone1)],
      ),
    );
  });
}
