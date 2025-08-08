String parseBackendError(dynamic error) {
  if (error == null) return 'Unknown error occurred';

  String message = error.toString();

  // Keep removing known prefixes until none match
  final prefixes = [
    'Exception:',
    'ServerpodClientException:',
    'ServerpodException:',
    'EndpointFailedException:',
    'FormatException:',
    'HttpException:',
  ];

  bool prefixRemoved;
  do {
    prefixRemoved = false;
    for (var prefix in prefixes) {
      if (message.startsWith(prefix)) {
        message = message.substring(prefix.length).trim();
        prefixRemoved = true;
      }
    }
  } while (prefixRemoved);

  return message;
}
