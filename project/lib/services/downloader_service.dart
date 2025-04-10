import 'package:tiktok_scraper/tiktok_scraper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:yt_downloader/features/downloader/downloader.dart';
import 'package:yt_downloader/features/downloader/downloader_tiktok_impl.dart';
import 'package:yt_downloader/features/downloader/downloader_youtube_impl.dart';
import 'package:yt_downloader/models/common_video.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';

class DownloaderService {
  static final String _youtubeRegex =
      r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/(watch\?v=|embed\/|v\/)?([A-Za-z0-9_-]{11})';
  static final String _tiktokRegex =
      r'^(https?:\/\/)?(www\.|m\.|vm\.)?tiktok\.com\/([A-Za-z0-9@._-]+\/video\/|t\/|@[A-Za-z0-9._-]+|video\/|[A-Za-z0-9_-]+)?\/?$';

  static Downloader? _ofLink(String link, DownloaderProvider provider) {
    if (RegExp(_youtubeRegex).hasMatch(link)) {
      return YoutubeDownloader(provider);
    } else if (RegExp(_tiktokRegex).hasMatch(link)) {
      return TiktokDownloader(provider);
    }
    return null;
  }

  static Future<CommonVideo> find(String link, DownloaderProvider provider) async {
    try {
      final downloader = _ofLink(link, provider);
      if (downloader == null) {
        provider.setStatusFailed();
        throw UnimplementedError('Enable to find downloader for link: "$link"');
      } else {
        return await downloader.getMetadata(link);
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> download(DownloaderProvider provider) async {
    if (provider.lastVideo == null) {
      throw Exception("No video found in provider");
    }
    if (provider.lastVideo!.source is Video) {
      await YoutubeDownloader(provider).download();
    } else if (provider.lastVideo!.source is TiktokVideo) {
      await TiktokDownloader(provider).download();
    } else {
      throw UnimplementedError(
          'Enable to find downloader for video type: "${provider.lastVideo!.source.runtimeType}"');
    }
  }
}
