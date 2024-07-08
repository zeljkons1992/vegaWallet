import 'package:equatable/equatable.dart';

enum DataStateStatus { success, error }

class DataState<T> extends Equatable {
  final DataStateStatus status;
  final T? data;
  final String? message;

  const DataState._({required this.status, this.data, this.message});

  factory DataState.success([T? data]) {
    return DataState._(status: DataStateStatus.success, data: data);
  }

  factory DataState.error(String message) {
    return DataState._(status: DataStateStatus.error, message: message);
  }

  @override
  List<Object?> get props => [status, data, message];
}
