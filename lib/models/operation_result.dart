///Result of any operation
class OperationResult<T> {
  String? error;

  T? data;

  OperationResult({this.data, this.error});

  bool isOk() => error == null;

  static OperationResult success() => OperationResult();
}
