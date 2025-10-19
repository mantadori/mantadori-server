void logConsole(String message, {Object? error, StackTrace? stackTrace}) {
  final time = DateTime.now().toIso8601String();
  final errText = error != null ? ' ERROR: $error' : '';
  final stackText = stackTrace != null ? '\n$stackTrace' : '';
  print('[$time] $message$errText$stackText');
}