import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:crypto/crypto.dart';

import 'entity/BaseEntity.dart';
import 'entity/BaseListEntity.dart';
import 'entity/ErrorEntity.dart';
import 'entity/NWMethod.dart';

class DioManager {
  static final DioManager _shared = DioManager._internal();
  factory DioManager() => _shared;

  Dio dio;

  DioManager._internal({String baseApi, Map headers}) {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        headers: headers,
        baseUrl: baseApi,
        contentType: Headers.jsonContentType,
        responseType: ResponseType.json,
        receiveDataWhenStatusError: false,
        connectTimeout: 30000,
        receiveTimeout: 3000,
      );
      dio = Dio(options);
    }
  }

  // 请求，返回参数为 T
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future request<T>(NWMethod method, String path, {Map<String, dynamic> params, Function(T) success, Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path, queryParameters: params, options: Options(method: NWMethodValues[method]));
      if (response != null) {
        BaseEntity entity = BaseEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          success(entity.data);
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }

  // 请求，返回参数为 List<T>
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future requestList<T>(NWMethod method, String path, {Map<String, dynamic> params, Function(List<T>) success, Function(ErrorEntity) error}) async {
    try {
      Response response = await dio.request(path, queryParameters: params, options: Options(method: NWMethodValues[method]));
      if (response != null) {
        BaseListEntity entity = BaseListEntity<T>.fromJson(response.data);
        if (entity.code == 0) {
          success(entity.data);
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }

  // 请求，返回参数为 T
  // method：请求方法，NWMethod.POST等
  // path：请求地址
  // params：请求参数
  // success：请求成功回调
  // error：请求失败回调
  Future uploadFile(String fileName, File file, {Function(Response response) success, Function(ErrorEntity) error}) async {
    try {
      //验证文本域
      int length = await file.length();
      String policyText = '{"expiration": "2090-01-01T12:00:00.000Z","conditions": [["content-length-range", 0, $length]]}';

      //进行utf8编码
      List<int> policyText_utf8 = utf8.encode(policyText);

      //进行base64编码
      String policy_base64 = base64.encode(policyText_utf8);

      //再次进行utf8编码
      List<int> policy = utf8.encode(policy_base64);

      String accesskey= '6EneSjqB6VXQhZoBYD2zHQI7VL52jb';

      //进行utf8 编码
      List<int> key = utf8.encode(accesskey);

      //通过hmac,使用sha1进行加密
      List<int> signature_pre  = new Hmac(sha1, key).convert(policy).bytes;

      //最后一步，将上述所得进行base64 编码
      String signature = base64.encode(signature_pre);
      String accesskeyId= 'LTAIX0soUpjuK2JJ';

      FormData data = FormData.fromMap({
        // 'Filename': 'Anything',
        'key' : fileName,
        'policy': policy_base64,
        'OSSAccessKeyId': accesskeyId,
        'success_action_status' : '200', //让服务端返回200，不然，默认会返回204
        'signature': signature,
        'file': MultipartFile.fromFile(file.path)
      });
      String url = "";
      Response response = await dio.request(url, data: data, options: Options(method: NWMethodValues[NWMethod.POST]));
      if (response != null) {
        BaseEntity entity = BaseEntity.fromJson(response.data);
        if (entity.code == 0) {
          success(response);
        } else {
          error(ErrorEntity(code: entity.code, message: entity.message));
        }
      } else {
        error(ErrorEntity(code: -1, message: "未知错误"));
      }
    } on DioError catch(e) {
      error(createErrorEntity(e));
    }
  }

  // 错误信息
  ErrorEntity createErrorEntity(DioError error) {
    switch (error.type) {
      case DioErrorType.CANCEL:{
        return ErrorEntity(code: -1, message: "请求取消");
      }
      break;
      case DioErrorType.CONNECT_TIMEOUT:{
        return ErrorEntity(code: -1, message: "连接超时");
      }
      break;
      case DioErrorType.SEND_TIMEOUT:{
        return ErrorEntity(code: -1, message: "请求超时");
      }
      break;
      case DioErrorType.RECEIVE_TIMEOUT:{
        return ErrorEntity(code: -1, message: "响应超时");
      }
      break;
      case DioErrorType.RESPONSE:{
        try {
          int errCode = error.response.statusCode;
          String errMsg = error.response.statusMessage;
          return ErrorEntity(code: errCode, message: errMsg);
        } on Exception catch(_) {
          return ErrorEntity(code: -1, message: "未知错误");
        }
      }
      break;
      default: {
        return ErrorEntity(code: -1, message: error.message);
      }
    }
  }
}