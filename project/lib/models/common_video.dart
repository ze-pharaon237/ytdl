import 'package:yt_downloader/utils/tools.dart';

class CommonVideo<T> {
  final String id;
  final String title;
  final String author;
  final String description;
  final String thumbnail;
  final String downloadUrl;
  late String updateDate;
  late String duration;
  final String sourceUrl;
  final T source;

  CommonVideo({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.thumbnail,
    required this.downloadUrl,
    required int duration,
    required DateTime updateDate,
    required this.sourceUrl,
    required this.source,
  }) {
    this.duration = formatDuration(duration);
    this.updateDate = formatDate(updateDate);
  }
}
