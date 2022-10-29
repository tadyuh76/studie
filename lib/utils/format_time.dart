String formatTime(int seconds) {
  final minutes = (seconds / 60).truncate();
  final minutesStr = (minutes % 60).toString().padLeft(2, '0');
  final secondsStr = (seconds % 60).toString().padLeft(2, '0');
  final formattedTime = "$minutesStr:$secondsStr";
  return formattedTime;
}
