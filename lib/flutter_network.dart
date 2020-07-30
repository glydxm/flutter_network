import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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

  //http网络请求框架
  static Future<String> _getByHttp(String url, {Map<String, String> params}) async {
    if (params != null && params.isNotEmpty) {
      // 如果参数不为空，则将参数拼接到URL后面
      StringBuffer sb = StringBuffer("?");
      params.forEach((key, value) {
        sb.write("$key" + "=" + "$value" + "&");
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0, paramStr.length - 1);
      url += paramStr;
    }
    try {
      http.Response res = await http.get(url, headers: _getHeader());
      Utf8Decoder utf8decoder = Utf8Decoder();
      String body = utf8decoder.convert(res.bodyBytes);
      return body;
    } catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  //http网络请求框架
  static Future<String> _postByHttp(String url, {Map<String, String> params}) async {
    try {
      http.Response res = await http.post(url, body: params, headers: _getHeader());
      Utf8Decoder utf8decoder = Utf8Decoder();
      String body = utf8decoder.convert(res.bodyBytes);
      return body;
    } catch (error) {
      print(error);
      return Future.error(error);
    }
  }

  //header生成
  static Map<String, String> _getHeader() {
    Map<String, String> header = Map();
    header['is_flutter_osc'] = "1";
    return header;
  }

  //http网络请求get
  static Future _getByPlatformHttp(String url, {Map<String, String> params}) async {
    return await _channel.invokeMethod("http_get", params);
  }

  //http网络请求post
  static Future _postByPlatformHttp(String url, {Map<String, String> params}) async {
    return await _channel.invokeMethod("http_post", params);
  }
}
