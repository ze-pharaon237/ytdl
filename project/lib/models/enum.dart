enum DownloaderStatus {
  pending(''),
  searching('Searching...'),
  searchingComplete('Searching complete'),
  createStream('Create stream ...'),
  checkDestinationDir('check destination directory ...'),
  downloading('Downloading...'),
  complete('Download complete!'),
  failed('Download failed!');

  final String message;

  const DownloaderStatus(this.message);

  @override
  String toString() {
    return message;
  }
}