import 'package:dio/dio.dart';

import '../../../domain/exception.dart';
import '../../../domain/type_def.dart';
import 'dart:developer' as developer;

abstract class BaseService {
  BaseService(this._dio);

  final Dio _dio;

  String get service;

  AsyncJson post(String path, {Object? data}) async {
    String apiPath = path;
    if (service.isEmpty && path.startsWith('/api/')) {
      // 动态服务
      apiPath = path.replaceFirst('/api/', '');
    }
    // https://91crapi.dyclub.co/api.php
    final realPath = '/api/$service$apiPath';
    final result = (await _dio.post(realPath, data: data)).data;
    if (result == null) {
      throw ResponseNullException();
    }
    //打印返回数据
    developer.log('RequstPath: ${_dio.options.baseUrl}$realPath, params: $data, \nResult: $result');
    return result;
  }
}
