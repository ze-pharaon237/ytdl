import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/models/downloader_model.dart';
import 'package:yt_downloader/models/enum.dart';
import 'package:yt_downloader/utils/downloader.dart';

class VideoDataWidget extends StatefulWidget {
  const VideoDataWidget({super.key});

  @override
  State<VideoDataWidget> createState() => _VideoDataWidgetState();
}

class _VideoDataWidgetState extends State<VideoDataWidget> {
  startDownloading() {
    var model = context.read<DownloaderModel>();
    Downloader(model, '', model.lastVideo).download();
  }

  @override
  Widget build(BuildContext context) {
    var model = context.watch<DownloaderModel>();
    var video = model.lastVideo;
    var status = model.status;
    return video == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 10,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  video.thumbnails.standardResUrl,
                  fit: BoxFit.fitWidth,
                ),
              ),
              Text('Title: ${video.title}'),
              Text('Duration: ${video.duration?.inMinutes} minutes'),
              Text('Author: ${video.author}'),
              Text('Publish at: ${video.uploadDateRaw}'),
              (status == DMStatus.downloading || status == DMStatus.complete)
                  ? Container()
                  : ElevatedButton(
                      onPressed: startDownloading, child: Text('Download')),
            ],
          );
  }
}
