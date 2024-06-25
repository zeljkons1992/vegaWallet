enum DataStateStatus { success, error }

class DataState<T> {
  final DataStateStatus status;
  final T? data;
  final String? message;

  DataState._({required this.status, this.data, this.message});

  factory DataState.success(T data) {
    return DataState._(status: DataStateStatus.success, data: data);
  }

  factory DataState.error(String message) {
    return DataState._(status: DataStateStatus.error, message: message);
  }
}
