import 'dart:async';
import 'dart:io';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/models/downloader_model.dart';
import 'package:yt_downloader/services/settings_service.dart';

class DownloaderService {
  final DownloaderModel _downloaderModel;
  late final YoutubeExplode _yt;
  late Video _metadata;

  DownloaderService(this._downloaderModel) : _yt = YoutubeExplode();

  Future<Video> getMetadata(String link) async {
    try {
      _downloaderModel.setStatusSearching();
      _metadata = await _yt.videos.get(link);
      _downloaderModel.setStatusSearchingComplete();
      return _metadata;
    } catch (e) {
      _downloaderModel.setStatusFailed();
      rethrow;
    }
  }

  Future<void> download(Video metadata) async {
    _metadata = metadata;
    try {
      _downloaderModel.init();
      _downloaderModel.setLastVideo(_metadata);
      _downloaderModel.startLoading();

      var manifest = await _yt.videos.streamsClient.getManifest(_metadata.id, ytClients: [
        YoutubeApiClient.android,
        YoutubeApiClient.androidVr
      ]);
      var streamInfo = manifest.muxed.withHighestBitrate();
      int totalBytes = streamInfo.size.totalBytes.toInt();
      var stream = _yt.videos.streamsClient.get(streamInfo);

      var downloadsPath = await _getDownloadsPath();
      if (downloadsPath == null) {
        _downloaderModel.stopLoading();
        return;
      }

      await _downloadFile(stream, downloadsPath, totalBytes);
      _downloaderModel.stopLoading();
      _downloaderModel.setStatusComplete();
    } catch (e) {
      _downloaderModel.stopLoading();
      _downloaderModel.setStatusFailed();
      rethrow;
    }
    _yt.close();
  }

  Future<String?> _getDownloadsPath() async {
    _downloaderModel.setStatusCheckDestinationDir();
    return SettingsService.getOrAskdownloadDirectoryPath(
      title: 'Select destination directory',
    );
  }

  Future<void> _downloadFile(Stream<List<int>> stream, String downloadsPath, int totalBytes) async {
    var file = File('$downloadsPath/${_metadata.title}.mp4');
    var fileStream = file.openWrite();

    int downloadedBytes = 0;

    await for (var data in stream) {
      fileStream.add(data);
      downloadedBytes += data.length;
      _downloaderModel.updateDownloadCounter(downloadedBytes, totalBytes);
    }

    await fileStream.flush();
    await fileStream.close();
    _downloaderModel.setLastDownloadPath(file.path);
  }
}
