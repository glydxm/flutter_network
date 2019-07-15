import 'dart:async';

import 'package:flutter/services.dart';

class FlutterNetwork {

  static const MethodChannel _channel =
      const MethodChannel('flutter_network');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // get请求的封装，传入的两个参数分别是请求URL和请求参数，请求参数以map的形式传入，会在方法体中自动拼接到URL后面
  static Future<String> get(String url, {Map<String, String> params}) async {
    return await _getByHttp(url, params: params);
  }

  // post请求的封装，传入的两个参数分别是请求URL和请求参数，请求参数以map的形式传入
  static Future<String> post(String url, {Map<String, String> params}) async {
    return await _postByHttp(url, params: params);
  }

  //http网络请求get
  static Future _getByHttp(String url, {Map<String, String> params}) async {
    await _channel.invokeMethod("http_get", params);
  }

  //http网络请求post
  static Future _postByHttp(String url, {Map<String, String> params}) async {
    await _channel.invokeMethod("http_post", params);
  }
}
