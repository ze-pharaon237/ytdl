import 'package:flutter/material.dart';
import 'package:yt_downloader/components/app_bar_menu.dart';
import 'package:yt_downloader/components/form.dart';
import 'package:yt_downloader/components/progress_bar.dart';
import 'package:yt_downloader/components/video_data.dart';
import 'package:yt_downloader/components/videos_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Yt Downloader'),
          actions: [AppBarMenuWidget()],
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              FormWidget(),
              VideoDataWidget(),
              ProgressBarWidget(),
              VideosListWidget(),
              Text('-------- end ---------'),
            ],
          ),
        ));
  }
}
