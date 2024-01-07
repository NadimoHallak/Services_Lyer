// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:generac/data_state.dart';

abstract class BaseServics {
  Dio dio = Dio();
  late Response response;
}

abstract class GenericModelFunction<T> {
  T fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap();

  String toJson() => json.encode(toMap());

  T fromJson(String source) =>
      fromMap(json.decode(source) as Map<String, dynamic>);
}

class ListModel<T extends GenericModelFunction<T>> {
  List<T> fromMapToListObject(int length, List data) {
    T? vareable;
    List<T> temp =
        List.generate(length, (index) => vareable!.fromMap(data[index]));
    return temp;
  }
}

class GeneracService<T extends GenericModelFunction<T>> extends BaseServics {
  Future<DataState<dynamic>> getData({
    required String baseUrl,
    String? idForSingelThings,
    String? token,
    String? queryParmeter,
  }) async {
    try {
      T? t;
      // discus token status
      if (token == null) {
        response = await dio.get(idForSingelThings == null
            ? baseUrl
            : '$baseUrl/$idForSingelThings');
      } else {
        response = await dio.get(
            idForSingelThings == null ? baseUrl : '$baseUrl/$idForSingelThings',
            options: Options(headers: {'token': token}));
      }
      // to easy use and write
      dynamic data = response.data;

      if (response.statusCode == 200) {
        // to know what is the type
        if (data is List) {
          // serlization
          List<T> list = ListModel<T>().fromMapToListObject(data.length, data);

          // return a data if it list
          return DataGetting<List<T>>(data: list);
        } else {
          // return a data if it map
          return DataGetting<T>(data: t!.fromMap(data));
        }
      } else {
        // if the request not success
        return DataError<T>(error: response.statusMessage.toString());
      }

      // Error handling
    } on DioException catch (e) {
      return DataException<T>(exception: e);
    } catch (e) {
      return DataError<T>(error: e.toString());
    }
  }

  Future<DataState<dynamic>> postData({
    required T object,
    required String baseUrl,
    String? token,
  }) async {
    try {
      if (token == null) {
        response = await dio.post(baseUrl, data: object.toJson());
      } else {
        response = await dio.post(
          baseUrl,
          data: object.toJson(),
          options: Options(headers: {'token': token}),
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
    // return DataError(error: "error"); //!   <============{
  }
}
