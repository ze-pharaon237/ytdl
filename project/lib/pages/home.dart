import 'package:flutter/material.dart';
import 'package:yt_downloader/components/form.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yt Downloader'),
      ),
      body: FormWidget(),
    );
  }

}