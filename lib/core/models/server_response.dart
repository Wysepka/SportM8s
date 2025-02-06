class ServerResponse {
  final bool isSuccess;
  final String? error;

  ServerResponse({
    required this.isSuccess,
    this.error,
  });
} 