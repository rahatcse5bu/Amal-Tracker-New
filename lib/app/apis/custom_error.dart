class CustomError {
  final String message;
  final int? code;
  final String? source;

  CustomError(int? statusCode, {
    required this.message,
    this.code,
    this.source,
  });

  @override
  String toString() {
    return 'CustomError: $message (code: $code, source: $source)';
  }
}
