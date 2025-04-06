import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yt_downloader/services/file_service.dart';
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
        future: LocalVideoService.loadFromFolder(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              spacing: 10,
              children: [
                ...snapshot.data!.map((entity) => Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => FileService.launchVideo(entity.path),
                        child: ListTile(
                            title: Text(
                              entity.path.split('/').last,
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
                              future: LocalVideoService.generateVideoThumbnail(
                                  entity.path),
                              builder: (leadingContext, leadingSnapshot) {
                                if (leadingSnapshot.hasData) {
                                  return Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      image: DecorationImage(
                                        image:
                                            MemoryImage(leadingSnapshot.data!),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: 56,
                                    width: 120,
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.lightBlueAccent),
                                    ),
                                  );
                                }
                              },
                            ),
                            trailing: InkWell(
                              onTap: () => _delete(entity),
                              child: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )),
                      ),
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

  void _delete(FileSystemEntity entity) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text('Delete confirmation'),
            content: Text('Are you sure to remove the file: ${entity.path} ?'),
            actions: [
              TextButton(
                  onPressed: () {
                    FileService.deleteVideo(entity.path);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No'))
            ],
          );
        });
  }
}
