import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/components/container_shadow.dart';
import 'package:yt_downloader/components/video_list_item.dart';
import 'package:yt_downloader/providers/video_provider.dart';

class VideosListWidget extends StatelessWidget {
  const VideosListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VideoProvider>(
      builder: (context, videoProvider, child) => _buildVideosList(videoProvider.videos),
    );
  }

  Widget _buildVideosList(List<FileSystemEntity> videos) {
    if (videos.isEmpty) {
      return const Center(child: Text("Aucun fichier vidéo trouvé."));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final entity = videos[index];
        return ContainerShadowWidget(child: VideoListItemWidget(entity: entity));
      },
    );
  }
}
