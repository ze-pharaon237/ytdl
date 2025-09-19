import 'package:flutter/material.dart';
import 'package:yt_downloader/components/app_bar_menu.dart';
import 'package:yt_downloader/components/form.dart';
import 'package:yt_downloader/components/video_data.dart';
import 'package:yt_downloader/components/videos_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Get the current theme

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'YT Downloader',
                  style: TextStyle(color: theme.colorScheme.primaryFixedDim), // Dynamic text color
                ),
                background: Image.asset('assets/images/header.png', fit: BoxFit.cover)),
            actions: [AppBarMenuWidget()],
          ),
          SliverToBoxAdapter(child: FormWidget()),
          SliverToBoxAdapter(child: VideoDataWidget()),
          VideosListWidget(),
          SliverPadding(padding: const EdgeInsets.only(top: 25)),
        ],
      ),
    );
  }
}
