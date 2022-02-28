class DioException implements Exception {
  final String message;

  DioException(this.message);

  @override
  String toString() {
    return message;
  }
}
