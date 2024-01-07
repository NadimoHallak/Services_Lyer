import 'package:dio/dio.dart';

abstract class DataState<T> {
  T? data;
  DioException? exception;
  String? error;

  DataState({this.data, this.error, this.exception});
}

class DataGetting<T> extends DataState<T> {
  DataGetting({required T data}) : super(data: data);
}

class DataError<T> extends DataState<T> {
  DataError({required String error}) : super(error: error);
}

class DataException<T> extends DataState<T> {
  DataException({required DioException exception}) : super(exception: exception);
}
