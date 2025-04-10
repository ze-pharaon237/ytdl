import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/models/common_video.dart';
import 'package:yt_downloader/features/downloader/downloader.dart';

class YoutubeDownloader extends Downloader {
  final YoutubeExplode _yt = YoutubeExplode();

  YoutubeDownloader(super.downloaderProvider);

  @override
  Future<CommonVideo<Video>> getMetadata(String link) async {
    try {
      downloaderProvider.setStatusSearching();
      final video = await _yt.videos.get(link);
      downloaderProvider.setStatusSearchingComplete();
      return CommonVideo<Video>(
          id: video.id.value,
          title: video.title,
          author: video.author,
          description: video.description,
          thumbnail: video.thumbnails.standardResUrl,
          downloadUrl: video.url,
          updateDate: video.uploadDate ?? DateTime.now(),
          duration: video.duration?.inSeconds ?? 0,
          sourceUrl: link,
          source: video);
    } catch (e) {
      downloaderProvider.setStatusFailed();
      rethrow;
    }
  }

  @override
  Future<void> download() async {
    final metadata = downloaderProvider.lastVideo!;
    try {
      downloaderProvider.init(video: metadata);
      downloaderProvider.setLastVideo(metadata);
      downloaderProvider.startLoading();

      downloaderProvider.setStatusCreateStream();
      var manifest = await _yt.videos.streamsClient.getManifest(metadata.id, ytClients: [YoutubeApiClient.android, YoutubeApiClient.androidVr]);
      var streamInfo = manifest.muxed.withHighestBitrate();
      int totalBytes = streamInfo.size.totalBytes.toInt();
      var stream = _yt.videos.streamsClient.get(streamInfo);

      await downloadFile(metadata, stream, totalBytes);
      downloaderProvider.stopLoading();
      downloaderProvider.setStatusComplete();
    } catch (e) {
      downloaderProvider.stopLoading();
      downloaderProvider.setStatusFailed();
      rethrow;
    } finally {
      _yt.close();
    }
  }
}
