import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/models/downloader_model.dart';

class DownloaderService {
  final String _link;
  final DownloaderModel _downloaderModel;
  late YoutubeExplode _yt; 
  late Video _metadata;

  DownloaderService(this._downloaderModel, this._link) {
    _yt = YoutubeExplode();
  }

  Future<Video> getMetadata() async {
    return await _yt.videos.get(_link);
  }

  Future<String> download(Video metadata) async {
    try {
      _downloaderModel.init();
      _downloaderModel.startLoading();
      _metadata = metadata; // Assign metadata to _metadata
      var stream = await _getStream();

      String? downloadsPath = await _getDownloadsPath();
      if (downloadsPath == null) {
        _downloaderModel.stopLoading();
        return 'Aucun répertoire sélectionné'; 
      }

      return await _downloadFile(stream, downloadsPath);
    } catch (e) {
      _downloaderModel.stopLoading();
      return 'Échec du téléchargement : $e';
    }
  }

  Future<Stream<List<int>>> _getStream() async {
    var manifest = await _yt.videos.streamsClient.getManifest(_metadata.id);
    var streamInfo = manifest.muxed.withHighestBitrate();
    return _yt.videos.streamsClient.get(streamInfo);
  }

  Future<String?> _getDownloadsPath() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  Future<String> _downloadFile(Stream<List<int>> stream, String downloadsPath) async {
    var file = File('$downloadsPath/${_metadata.title}.mp4');
    var fileStream = file.openWrite();

    int totalBytes = await _getTotalBytes(stream);
    int downloadedBytes = 0;

    var transformer = StreamTransformer<List<int>, List<int>>.fromHandlers(
      handleData: (data, sink) {
        fileStream.add(data);
        downloadedBytes += data.length;
        _downloaderModel.updateCount(downloadedBytes, totalBytes);
        sink.add(data);
      }
    );

    await stream.transform(transformer).drain();

    await fileStream.flush();
    await fileStream.close();
    _downloaderModel.stopLoading();
    return file.path;
  }

  Future<int> _getTotalBytes(Stream<List<int>> stream) async {
    // Calculer la taille totale du fichier à partir du manifest
    // Cela peut nécessiter une implémentation différente selon la bibliothèque YoutubeExplode
    var totalBytes = (await stream.length).toInt(); 
    return totalBytes;
  }
}
