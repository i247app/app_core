import 'dart:io';

import 'package:flutter/widgets.dart';

class FileController extends ValueNotifier<File?> {
  FileController({File? file}) : super(file == null ? null : file);

  FileController.fromValue(File file) : super(file);

  File? get file => this.value;

  set file(File? newFile) => this.value = newFile;
}
