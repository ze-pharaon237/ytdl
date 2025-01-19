import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Downloader {
  final String _link;
  late YoutubeExplode _yt; 
  late Video _metadata;

  Downloader(this._link) {
    _yt = YoutubeExplode();
  }

  Future<Downloader> getMetadata() async {
    var video  = await _yt.videos.get(_link);
    _metadata = video;
    return this;
  }

  Future<String> download() async {
    var manifest = await _yt.videos.streams.getManifest(
      _metadata.id,
      ytClients: [
        YoutubeApiClient.android,
        YoutubeApiClient.androidVr
      ]
    );
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

    await stream.pipe(fileStream);

    await fileStream.flush();
    await fileStream.close();

    return file.path;
  }
}