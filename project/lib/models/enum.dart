enum DMStatus {
  pending(''),
  searching('Searching...'),
  searchingComplete('Searching complete'),
  createStream('Create stream ...'),
  checkDestinationDir('check destination directory ...'),
  downloading('Downloading...'),
  complete('Download complete!'),
  failed('Download failed!');

  final String message;

  const DMStatus(this.message);

  @override
  String toString() {
    return message;
  }
}