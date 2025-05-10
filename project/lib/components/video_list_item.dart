import 'dart:io';

import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yt_downloader/components/video_delete_dialog.dart';
import 'package:yt_downloader/providers/video_provider.dart';
import 'package:yt_downloader/services/file_service.dart';
import 'package:yt_downloader/services/local_videos_service.dart';

class VideoListItemWidget extends StatelessWidget {
  final FileSystemEntity entity;

  const VideoListItemWidget({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () => FileService.launchVideo(entity.path),
      child: ListTile(
          title: Text(
            basename(entity.path),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            'Taille: ${(entity.statSync().size / 1000 / 1000).toStringAsFixed(2)}Mo',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          leading: FutureBuilder(
            future: LocalVideoService.getVideoThumbnail(entity),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
              } else {
                return SizedBox(
                  height: 70,
                  width: 70,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                    ),
                  ),
                );
              }
            },
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () => _share(entity),
                child: Icon(
                  Icons.share,
                  color: Colors.blue,
                ),
              ),
              SizedBox(width: 10),
              InkWell(
                onTap: () => VideoDeleteDialog.show(context, entity, Provider.of<VideoProvider>(context, listen: false).reloadVideos),
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          )),
    );
  }

  void _share(FileSystemEntity entity) {
    final params = ShareParams(
      title: "Share video: ${basename(entity.path)}",
      files: [XFile(entity.path)],
    );
    SharePlus.instance.share(params);
  }
}
