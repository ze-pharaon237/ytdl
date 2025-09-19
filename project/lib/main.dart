import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:yt_downloader/providers/downloader_provider.dart';
import 'package:yt_downloader/pages/home.dart';
import 'package:yt_downloader/providers/video_provider.dart';

void main() async {
  if (kDebugMode) {
    fixDebugVMServiceLog();
  }

  // enable inAppWebView
  WidgetsFlutterBinding.ensureInitialized();

  // enable inspection
  if (kDebugMode && kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DownloaderProvider()), 
        ChangeNotifierProvider(create: (_) => VideoProvider())
      ],
      child: MaterialApp(
        title: 'YT Downloader',
        theme: ThemeData.dark(
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

Future<void> fixDebugVMServiceLog() async {
  ServiceProtocolInfo serviceProtocolInfo = await Service.getInfo();
  final message = 'The Dart VM service is listening on ${serviceProtocolInfo.serverUri}';
  throw Exception(message);
}
