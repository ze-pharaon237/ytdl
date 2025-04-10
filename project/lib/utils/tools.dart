String formatDuration(int seconds) {
  int minutes = seconds ~/ 60;
  int remainingSeconds = seconds % 60;
  
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

  return "$formattedMinutes:$formattedSeconds min";
}

String formatDate(DateTime date) {
  return "${date.day.toString().padLeft(2, '0')}/"
         "${date.month.toString().padLeft(2, '0')}/"
         "${date.year} "
         "${date.hour.toString().padLeft(2, '0')}:"
         "${date.minute.toString().padLeft(2, '0')}:"
         "${date.second.toString().padLeft(2, '0')}";
}