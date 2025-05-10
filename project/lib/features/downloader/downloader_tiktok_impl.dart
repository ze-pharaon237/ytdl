import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tiktok_scraper/tiktok_scraper.dart';
import 'package:yt_downloader/models/common_video.dart';
import 'package:yt_downloader/features/downloader/downloader.dart';

class TiktokDownloader extends Downloader {
  late HeadlessInAppWebView? headlessWebView;
  CookieManager cookieManager = CookieManager.instance();
  final tiktokCookieDomain = 'https://www.tiktok.com';
  final downloadURlQuerySelector = "document.querySelector('video').children[0].src";

  TiktokDownloader(super.downloaderProvider);

  @override
  Future<CommonVideo<TiktokVideo>> getMetadata(String link) async {
    try {
      downloaderProvider.setStatusSearching();
      final video = await TiktokScraper.getVideoInfo(link);
      downloaderProvider.setStatusSearchingComplete();
      return CommonVideo<TiktokVideo>(
          id: video.id,
          title: video.id,
          author: video.author.username,
          description: video.description,
          thumbnail: video.thumbnail,
          downloadUrl: video.downloadUrls[0],
          duration: (video.duration / 10).toInt(),
          updateDate: DateTime.fromMillisecondsSinceEpoch(int.parse(video.createTime) * 1000),
          sourceUrl: link,
          source: video);
    } catch (e) {
      downloaderProvider.setStatusFailed();
      rethrow;
    }
  }

  @override
  Future<void> download() async {
    final video = downloaderProvider.lastVideo;
    downloaderProvider.init();
    downloaderProvider.setLastVideo(video!);
    downloaderProvider.startLoading();
    downloaderProvider.setStatusGetVideo();
    downloaderProvider.setStatusDetail('tiktok: Create headlessWB');
    await _createHeadlessWebView(downloaderProvider.lastVideo!.sourceUrl);
    downloaderProvider.setStatusDetail('tiktok: Run headlessWB');
    await headlessWebView?.run();

    Timer(Duration(seconds: 10), () async {
      if (headlessWebView != null && headlessWebView!.isRunning()) {
        log('Timeout reached, stopping WebView...');
        _abortDownload();
      }
    });
  }

  void _abortDownload() {
    downloaderProvider.stopLoading();
    downloaderProvider.setStatusFailed();
    headlessWebView?.dispose();
  }

  Future<void> _createHeadlessWebView(String url) async {
    var isRedirect = false;
    headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        isInspectable: kDebugMode,
        preferredContentMode: UserPreferredContentMode.DESKTOP,
      ),
      onTitleChanged: (controller, title) async {
        downloaderProvider.setStatusDetail("tiktok: catch title changed on $title");
        if (!isRedirect && !title!.contains('TikTok - Make Your Day') && (await controller.getProgress() ?? 0) >= 100) {
          isRedirect = true;
          final String? downloadUrl = await controller.evaluateJavascript(source: downloadURlQuerySelector);
          downloaderProvider.setStatusDetail('tiktok: onTitleChanged with expected title');

          if (downloadUrl != null) {
          downloaderProvider.setStatusDetail('tiktok: Url found :');
            final cookies = (await cookieManager.getCookies(url: WebUri(tiktokCookieDomain)))
                .where((c) => c.isHttpOnly == true)
                .map((co) => '${co.name}=${co.value}')
                .join('; ');
            log('cookie: $cookies');
            headlessWebView?.dispose();
            _fetchVideo(downloadUrl, cookies);
          } else {
            _abortDownload();
            throw Exception('Enable to find downloadUrl.');
          }
        }
      },
    );
  }

  void _fetchVideo(String downloadUrl, String cookie) async {
    final url = Uri.parse(downloadUrl);
    HttpClient client = HttpClient();
    downloaderProvider.setStatusGetVideo();

    try {
      final request = await client.getUrl(url);
      request.headers.set(HttpHeaders.cookieHeader, cookie);

      downloaderProvider.setStatusDetail('tiktok: Send video request');
      final response = await request.close();

      if (response.statusCode == HttpStatus.ok) {
        downloaderProvider.setStatusDetail('tiktok: Got response OK');
        final totalBytes = response.contentLength;

        downloaderProvider.setStatusDetail('tiktok: Create stream');
        Stream<List<int>> stream = response.asBroadcastStream();

        downloaderProvider.setStatusDownloading();
        await downloadFile(downloaderProvider.lastVideo!, stream, totalBytes);
        downloaderProvider.stopLoading();
        downloaderProvider.setStatusComplete();
      } else {
        log('request fail with code ${response.statusCode}');
        throw Exception('request fail with code ${response.statusCode}');
      }
    } catch (e) {
      downloaderProvider.stopLoading();
      downloaderProvider.setStatusFailed();
      rethrow;
    } finally {
      client.close();
    }
  }
}
