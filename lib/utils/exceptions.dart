class DbException implements Exception {
  final String message;
  DbException(this.message);

  @override
  String toString() {
    return 'DbException: $message';
  }
}
