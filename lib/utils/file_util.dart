import 'dart:io';

import 'package:image_picker/image_picker.dart';

class FileUtils {
  FileUtils._();

  static Future<File?> pickIMage() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      File file = File(xFile.path);
      return file;
    }
    return null;
  }
}
