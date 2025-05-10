import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart';
import 'package:get_thumbnail_video/index.dart';
import 'package:get_thumbnail_video/video_thumbnail.dart';
import 'package:yt_downloader/services/file_service.dart';
import 'package:yt_downloader/services/settings_service.dart';

class LocalVideoService {
  static Future<List<FileSystemEntity>> loadFromFolder() async {
    final dirPath = await SettingsService.getDownloadDirectoryPath();
    if (dirPath == null) return List.empty();
    var result = await FileService.loadDirectoryContent(dirPath);

    return result;
  }

  static Future<Uint8List> _generateVideoThumbnail(String path) async {
    return await VideoThumbnail.thumbnailData(
        video: path,
        imageFormat: ImageFormat.PNG,
        maxWidth: 100,
        maxHeight: 100,
        quality: 50);
  }

  static Future<File?> getVideoThumbnail(FileSystemEntity entity) async {
    final downloadPath = await SettingsService.getOrAskdownloadDirectoryPath();
    if (downloadPath == null) {
      return null;
    }

    final Directory downloadDir = Directory("$downloadPath/.thumbnail");
    downloadDir.createSync();

    File thumbnail = File('$downloadPath/.thumbnail/${basename(entity.path)}.png');
    if (thumbnail.existsSync()) {
      return thumbnail;
    } else {
      return _saveVideoThumbnail(entity, '$downloadPath/.thumbnail');
    }
  }

  static Future<File> _saveVideoThumbnail(FileSystemEntity entity, String thumbnailPath) async {
    final bytes = await _generateVideoThumbnail(entity.path);
    final thumbnail = File("$thumbnailPath/${basename(entity.path)}.png");
    await thumbnail.writeAsBytes(bytes);
    return thumbnail;
  }
}
