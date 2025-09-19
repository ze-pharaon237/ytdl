import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:yt_downloader/services/file_service.dart';
import 'package:yt_downloader/services/settings_service.dart';
import 'package:yt_downloader/utils/tools.dart';

class LocalVideoService {
  static Future<List<FileSystemEntity>> loadFromFolder() async {
    final dirPath = await SettingsService.getDownloadDirectoryPath();
    if (dirPath == null) return List.empty();
    final result = await FileService.loadDirectoryContent(dirPath, '.mp4');

    return result;
  }

  static Future<Uint8List> _generateVideoThumbnail(String path) async {
    return await VideoThumbnail.thumbnailData(video: path, imageFormat: ImageFormat.PNG, maxWidth: 100, maxHeight: 100, quality: 50);
  }

  static Future<File?> getVideoThumbnail(FileSystemEntity entity) async {
    final downloadPath = await SettingsService.getOrAskdownloadDirectoryPath();
    if (downloadPath == null) {
      return null;
    }

    final Directory downloadDir = Directory('$downloadPath/.thumbnail');
    downloadDir.createSync();

    File thumbnail = File('$downloadPath/.thumbnail/${sanitizeFileName(basename(entity.path))}.png');
    if (thumbnail.existsSync()) {
      return thumbnail;
    } else {
      return _saveVideoThumbnail(entity, '$downloadPath/.thumbnail');
    }
  }

  static Future<void> cleanThumbnails() async {
    final dirPath = await SettingsService.getDownloadDirectoryPath();
    if (dirPath == null) return;

    final result = await FileService.loadDirectoryContent('$dirPath/.thumbnail', '.png');
    for (var file in result) {
      final filename = basename(file.path);
      String videoName = '$dirPath/${filename.substring(0, filename.lastIndexOf('.png'))}';
      if (!File(videoName).existsSync()) {
        file.deleteSync();
      }
    }
  }

  static Future<File> _saveVideoThumbnail(FileSystemEntity entity, String thumbnailPath) async {
    final bytes = await _generateVideoThumbnail(entity.path);
    final thumbnail = File('$thumbnailPath/${sanitizeFileName(basename(entity.path))}.png');
    await thumbnail.writeAsBytes(bytes);
    return thumbnail;
  }
}
