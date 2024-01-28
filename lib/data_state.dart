import 'package:dio/dio.dart';

abstract class DataState<T> {
  T? data;
  DioException? exception;
  String? error;
  String? message;

  DataState({this.data, this.error, this.exception, this.message});
}

class DataMessage<T> extends DataState<T> {
  DataMessage({required String message}) : super(message: message);
}

class DataGetting<T> extends DataState<T> {
  DataGetting({required T data}) : super(data: data);
}

class DataError<T> extends DataState<T> {
  DataError({required String error}) : super(error: error);
}

class DataException<T> extends DataState<T> {
  DataException({required DioException exception})
      : super(exception: exception);
}
