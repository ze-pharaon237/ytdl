import 'package:flutter/material.dart';
import 'package:yt_downloader/services/local_videos_service.dart';

class VideosListWidget extends StatefulWidget {
  const VideosListWidget({super.key});

  @override
  State<VideosListWidget> createState() => _VideosListWidgetState();
}

class _VideosListWidgetState extends State<VideosListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: LocalVideoService.loadFromFolder(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return ListView.builder(
            //   itemCount: snapshot.data!.length,
            //   itemBuilder: (context, index) {
            //     return ListTile(
            //       title: Text(snapshot.data!.elementAt(index).path.split('/').last),
            //       tileColor: Colors.lightBlue,
            //     );
            //   },
            // );
            return Column(
              spacing: 10,
              children: [
                ...snapshot.data!.map((entity) => ListTile(
                  tileColor: Colors.white,
                      title: Text(
                        entity.path.split('/').last,
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Text(
                          'Size: ${(entity.statSync().size / 1000 / 1000).toStringAsFixed(2)}Mo', style: TextStyle(fontSize: 10)),
                      leading: FutureBuilder(
                          future: LocalVideoService.generateVideoThumbnail(
                              entity.path),
                          builder: (leadingContext, leadingSnapshot) {
                            if (leadingSnapshot.hasData) {
                              return Image.memory(
                                leadingSnapshot.data!,
                                height: 56,
                                width: 100,
                                fit: BoxFit.cover,
                              );
                            } else {
                              return Text('Loading...');
                            }
                          }),
                      trailing: Icon(Icons.delete, color: Colors.red),
                      // tileColor: Colors.lightBlue,
                      // shape: RoundedRectangleBorder(
                      //   side: BorderSide(color: Colors.blueGrey, width: 1),
                      //   borderRadius: BorderRadius.circular(15),
                      // ),
                    ))
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return Text('loading...');
          }
        });
  }
}
