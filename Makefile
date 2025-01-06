project: pub models

models:
	flutter packages pub run build_runner build --delete-conflicting-outputs

pub: clean
	rm -f pubspec.lock
	flutter pub upgrade
	flutter pub get

clean:
	flutter clean
	rm -f lib/model/*.g.dart
	rm -f lib/model/response/*.g.dart
