import 'dart:async';
import 'dart:io';
import 'package:yt_downloader/models/common_video.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';
import 'package:yt_downloader/services/settings_service.dart';

abstract class Downloader {
  final DownloaderProvider downloaderProvider;

  Downloader(this.downloaderProvider);

  Future<CommonVideo> getMetadata(String link);

  Future<void> download();

  Future<String?> getDownloadsPath() async {
    downloaderProvider.setStatusCheckDestinationDir();
    return SettingsService.getOrAskdownloadDirectoryPath(
      title: 'Select destination directory',
    );
  }

  Future<void> downloadFile(CommonVideo video, Stream<List<int>> stream, int totalBytes) async {
    
    var downloadsPath = await getDownloadsPath();
    if (downloadsPath == null) {
      downloaderProvider.stopLoading();
      return;
    }

    var file = File('$downloadsPath/${video.title}.mp4');
    var fileStream = file.openWrite();
    downloaderProvider.setLastDownloadPath(file.path);

    int downloadedBytes = 0;

    await for (var data in stream) {
      fileStream.add(data);
      downloadedBytes += data.length;
      downloaderProvider.updateDownloadCounter(downloadedBytes, totalBytes);
    }

    await fileStream.flush();
    await fileStream.close();
  }
}
