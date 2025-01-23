import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:yt_downloader/services/file_service.dart';
import 'package:yt_downloader/services/settings_service.dart';

class LocalVideoService {
  static Future<List<FileSystemEntity>> loadFromFolder(context) async {
    final dirPath = await SettingsService.getDownloadDirectoryPath();
    if (dirPath == null) return List.empty();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('loadFromFolder: $dirPath')));
    var result = await FileService.loadDirectoryContent(dirPath, context);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('loadFromFolder-result: ${result.length}')));

    return result;
  }

  static Future<Uint8List> generateVideoThumbnail(String path) async {
    return await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 100,
        maxHeight: 100,
        quality: 25);
  }
}
