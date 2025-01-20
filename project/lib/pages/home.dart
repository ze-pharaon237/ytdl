import 'package:flutter/material.dart';
import 'package:yt_downloader/components/form.dart';
import 'package:yt_downloader/components/progress_bar.dart';
import 'package:yt_downloader/components/video_data.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yt Downloader'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: ListView(
        children: [
          FormWidget(),
          SizedBox(height: 25),
          VideoDataWidget(),
          SizedBox(height: 25),
          ProgressBarWidget(), 
        ],
      ),
      )
    );
  }
}
