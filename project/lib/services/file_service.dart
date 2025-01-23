import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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

  static Future<List<FileSystemEntity>> loadDirectoryContent(String dirPath, context) async {
     var dir = Directory(dirPath);
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('loadDirectoryContent: ${dir.absolute} - ${dir.existsSync()}')));
     var list = dir.listSync(recursive: false, followLinks: false);
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('loadDirectoryContent: list - ${list.length}')));
     return list.where((entity) => entity.path.endsWith('.mp4')).toList();
  }
}
