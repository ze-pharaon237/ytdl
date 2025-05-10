enum DownloaderStatus {
  pending('', 0),
  searching('Searching...', 1),
  searchingComplete('Searching complete', 2),
  checkDestinationDir('check destination directory ...' ,3),
  getVideo("Get Video", 4),
  downloading('Downloading...', 5),
  complete('Download complete!', 6),
  failed('Download failed!', 6);

  final String message;
  final int weight;

  const DownloaderStatus(this.message, this.weight);
}