class AppException<T> implements Exception {
  final String message;
  AppException(this.message);
  
  @override
  String toString() {
    return '$runtimeType: $message';
  }
}

class DataException extends AppException {
  DataException(super.message);
}

class DbException extends AppException {
  DbException(super.message);
}
