import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';
import 'package:yt_downloader/models/enum.dart';
import 'package:yt_downloader/services/downloader_service.dart';

class VideoDataWidget extends StatefulWidget {
  const VideoDataWidget({super.key});

  @override
  State<VideoDataWidget> createState() => _VideoDataWidgetState();
}

class _VideoDataWidgetState extends State<VideoDataWidget> {
  startDownloading() {
    final provider = context.read<DownloaderProvider>();
    DownloaderService.download(provider);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DownloaderProvider>();
    var video = provider.lastVideo;
    var status = provider.status;
    return (video == null || status == DownloaderStatus.complete)
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  video.thumbnail,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Text('Title: ${video.title}'),
              Text(video.description),
              Text('Duration: ${video.duration}'),
              Text('Author: ${video.author}'),
              Text('Publish at: ${video.updateDate}'),
              (status == DownloaderStatus.downloading || status == DownloaderStatus.complete)
                  ? Container()
                  : ElevatedButton(onPressed: startDownloading, child: Text('Download')),
            ],
          );
  }
}
