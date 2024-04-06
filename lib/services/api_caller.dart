import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'storage.dart';

class ApiCaller {
  // static const host = 'http://localhost:3000';
  // static const host = 'https://dummyjson.com';
  // static const baseUrl = '$host';
  static const host = 'https://myapi-two-swart.vercel.app';
  static final _dio = Dio(BaseOptions(responseType: ResponseType.plain));

  Future<String> get(String baseUrl, String endpoint, {Map<String, dynamic>? params}) async {
    try {
      final response = await _dio.get('$baseUrl/$endpoint', queryParameters: params);

      debugPrint('Status code: ${response.statusCode}');
      debugPrint(response.data.toString());
      return response.data;
    } on DioException catch (e) {
      var msg = e.response?.data.toString();
      debugPrint(msg);
      throw Exception(msg);
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future<String> post(String baseUrl, String endpoint, {required Map<String, dynamic>? params}) async {
    try {
      var token = await Storage().read(Storage.keyToken);
      _dio.options.headers["Authorization"] = "Bearer $token";
      final response = await _dio.post('$baseUrl/$endpoint', data: params);

      debugPrint(response.data.toString());
      return response.data.toString();
    } catch (e) {
      // TODO:
      rethrow;
    }
  }
}
