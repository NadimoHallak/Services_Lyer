// ignore_for_file: public_member_api_docs, sort_constructors_first, constant_identifier_names, camel_case_types

import 'package:dio/dio.dart';

import 'package:generac/data_state.dart';
import 'package:logger/logger.dart';

abstract class _BaseServics {
  Dio dio = Dio();
  late Response response;
}

abstract class GenericModelFunction<T> {
  T fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();

  String toJson();

  T fromJson(String source);
}

class _ListModel<T extends GenericModelFunction<T>> {
  List<T> fromMapToListObject(int length, List data) {
    T? variable;
    List<T> temp =
        List.generate(length, (index) => variable!.fromMap(data[index]));
    return temp;
  }
}

class GeneracService<T extends GenericModelFunction<T>> extends _BaseServics {
  final Logger _logger = Logger();
  Future<DataState<dynamic>> getData({
    required String baseUrl,
    String? getSingel,
    String? queryParmeter,
    Map<String, dynamic>? header,
  }) async {
    try {
      _logger.d('get method working');

      T? t;

      if (header == null) {
        _logger.i("there is no header");
        response = await dio.get(
          (getSingel == null)
              ? (queryParmeter == null)
                  ? baseUrl
                  : baseUrl + queryParmeter
              : (queryParmeter == null)
                  ? '$baseUrl/$getSingel'
                  : '$baseUrl/$getSingel$queryParmeter',
        );
      } else {
        _logger.i("header is exist !");
        response = await dio.get(
          (getSingel == null)
              ? (queryParmeter == null)
                  ? baseUrl
                  : baseUrl + queryParmeter
              : (queryParmeter == null)
                  ? '$baseUrl/$getSingel'
                  : '$baseUrl/$getSingel$queryParmeter',
          options: Options(headers: header),
        );
      }
      //* to easy use and write
      dynamic data = response.data;
      int? statusCode = response.statusCode;

      switch (statusCode) {
        case 200:
          _logger.i('status code is 200 ===> OK');
          if (data is List) {
            _logger.i('data is list');
            List<T> list =
                _ListModel<T>().fromMapToListObject(data.length, data);
            _logger.f('list =  $list');
            return DataGetting<List<T>>(data: list);
          } else {
            // _logger.f('the data is map \n map = ${t!.fromMap(data)} ');
            print(response.data);
            dynamic temp = t!.fromMap(response.data);
            return DataGetting<T>(data: temp);
          }
        case 201:
          _logger.i('status code is 201 ===> CREATED');

          return DataMessage<T>(message: "$statusCode\n${STATUS.CREATED}");
        case 205:
          _logger.i('status code is 205 ===> RESET CONECT');
          return DataMessage<T>(
              message: "$statusCode\n${STATUS.RESET_CONNECT}");
        case 302:
          _logger.i('status code is 302 ===> FOUND');
          return DataMessage<T>(message: "$statusCode\n${STATUS.FOUND}");
        case 400:
          _logger.i('status code is 400 ===> BAD REQUEST');
          return DataError<T>(error: "$statusCode\n${STATUS.BAD_REQUEST}");
        case 401:
          _logger.i('status code is 401 ===> UNAUTHORIZED');
          return DataError<T>(error: "$statusCode\n${STATUS.UNAUTHORIZED}");
        case 402:
          _logger.i('status code is 402 ===> PAYMENT REQUIRED');
          return DataError<T>(error: "$statusCode\n${STATUS.PAYMENT_REQUIRED}");
        case 403:
          _logger.i('status code is 403 ===> FORBIDDEN');
          return DataError<T>(error: "$statusCode\n${STATUS.FORBIDDEN}");
        case 404:
          _logger.i('status code is 404 ===> NOT FOUND');
          return DataError<T>(error: "$statusCode\n${STATUS.NOT_FOUND}");
        case 405:
          _logger.i('status code is 405 ===> MATHOD NOT ALLOWED');
          return DataError<T>(
              error: "$statusCode\n${STATUS.MATHOD_NOT_ALLOWED}");
        case 422:
          _logger.i('status code is 422 ===> UNPROCESSABLE ENTITY');
          return DataError<T>(
              error: "$statusCode\n${STATUS.UNPROCESSABLE_ENTITY}");
        case 500:
          _logger.i('status code is 500 ===> INTERNET SERVER ERROR');
          return DataError<T>(
              error: "$statusCode\n${STATUS.INTERNET_SERVER_ERROR}");
        case 503:
          _logger.i('status code is 503 ===> SERVICE_UNAVAILABLE');
          return DataError<T>(
              error: "$statusCode\n${STATUS.SERVICE_UNAVAILABLE}");
        default:
          _logger.i('this error is not recommended');
          return DataError<T>(error: "$statusCode\n${response.statusMessage}");
      }
    } on DioException catch (e) {
      _logger.w('there is exeption from dio\n${e.error}\n${e.message}');
      return DataException<T>(exception: e);
    } catch (e) {
      _logger.w('there is an exeption\n${e.toString()}');
      return DataError<T>(error: e.toString());
    }
  }

  Future<DataState<dynamic>> postData({
    required T object,
    required String baseUrl,
    Map<String, dynamic>? header,
    String? queryParmeter,
  }) async {
    try {
      if (header == null) {
        response = await dio.post(baseUrl, data: object.toJson());
      } else {
        response = await dio.post(
          baseUrl,
          data: object.toJson(),
          options: Options(headers: header),
        );
      }
      if (response.statusCode == 200) {
        return DataGetting<T>(data: response.data);
      } else {
        return DataError<T>(error: response.statusMessage.toString());
      }
    } on DioException catch (e) {
      return DataException<T>(exception: e);
    } catch (e) {
      return DataError<T>(error: e.toString());
    }
  }
}

enum STATUS {
  OK,
  CREATED,
  RESET_CONNECT,
  FOUND,
  BAD_REQUEST,
  UNAUTHORIZED,
  PAYMENT_REQUIRED,
  FORBIDDEN,
  NOT_FOUND,
  MATHOD_NOT_ALLOWED,
  UNPROCESSABLE_ENTITY,
  INTERNET_SERVER_ERROR,
  SERVICE_UNAVAILABLE,
}
