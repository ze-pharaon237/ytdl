import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';

class FileService {
  static Future<String?> selectDirectoryPath({String? title}) async {
    var path = await FilePicker.platform
        .getDirectoryPath(dialogTitle: title ?? 'Select directory');
    return path;
  }

  static Future launchVideo(String path) async {
    return await OpenFile.open(path);
  }

  static void deleteVideo(String path) {
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    } else {
      throw Exception('File $path does not exist !');
    }
  }

  static Future<List<FileSystemEntity>> loadDirectoryContent(
      String dirPath) async {
    var list =
        Directory(dirPath).listSync(recursive: false, followLinks: false);
    return list.where((entity) => entity.path.endsWith('.mp4')).toList();
  }
}
