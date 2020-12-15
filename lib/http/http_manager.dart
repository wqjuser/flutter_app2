import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app2/http/api.dart';

class HttpManager {
  Dio _dio;
  static HttpManager _instance;

  factory HttpManager.getInstance() {
    if (null == _instance) {
      _instance = new HttpManager._internalInstance();
    }
    return _instance;
  }

  HttpManager._internalInstance() {
    BaseOptions options = new BaseOptions(
      baseUrl: Api.baseUrl,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    _dio = new Dio(options);
  }

  request(url, {String method = "get"}) async {
    try {
      Options options = new Options(method: method);
      Response response = await _dio.request(url, options: options);
      return response.data;
    } catch (e){
      print("网络请求异常");
      debugPrint(e);
      return null;
    }
  }
}
