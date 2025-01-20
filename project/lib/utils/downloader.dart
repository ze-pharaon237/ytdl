import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/models/downloader_model.dart';

class Downloader {
  final String _link;
  final DownloaderModel _downloaderModel;
  late YoutubeExplode _yt;
  late Video _metadata;

  Downloader(this._downloaderModel, this._link, [Video? metadata]) {
    _yt = YoutubeExplode();
    if (metadata != null) _metadata = metadata;
  }

  Future<Video> getMetadata() async {
    _downloaderModel.setSearching();
    var video = await _yt.videos.get(_link);
    _metadata = video;
    _downloaderModel.setSearchingComplete();
    return _metadata;
  }

  Future<void> launchVideo(String filePath) async {
    await OpenFile.open(filePath);
  }

  Future<String> download() async {
    _downloaderModel.init();
    _downloaderModel.setLastVideo(_metadata);
    _downloaderModel.startLoading();
    var manifest = await _yt.videos.streams.getManifest(_metadata.id,
        ytClients: [YoutubeApiClient.android, YoutubeApiClient.androidVr]);
    var streamInfo = manifest.muxed.withHighestBitrate();

    var stream = _yt.videos.streams.get(streamInfo);

    // Directory? cacheDirectory = await getDownloadsDirectory();
    // String downloadsPath = cacheDirectory!.path;

    String? downloadsPath = await FilePicker.platform.getDirectoryPath();
    if (downloadsPath == null) {
      return 'Aucun répertoire sélectionné';
    }

    var file = File('$downloadsPath/${_metadata.title}.mp4');
    var fileStream = file.openWrite();

    int totalBytes = streamInfo.size.totalBytes.toInt();
    int downloadedBytes = 0;

    var transformer = StreamTransformer<List<int>, List<int>>.fromHandlers(
        handleData: (data, sink) {
      fileStream.add(data);
      downloadedBytes += data.length;
      _downloaderModel.updateCount(downloadedBytes, totalBytes);
      sink.add(data);
    });
    await stream.transform(transformer).drain();

    await fileStream.flush();
    await fileStream.close();
    _downloaderModel.stopLoading();
    _downloaderModel.setLastDownloadPath(file.path);

    await launchVideo(file.path);

    return file.path;
  }
}
