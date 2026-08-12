import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../../app/config/app_config.dart';
import '../services/device/device_service.dart';
import 'api_exception.dart';

class ApiClient {
  late final Dio dio;
  final Future<String?> Function() getToken;
  final DeviceService deviceService;

  ApiClient({required this.getToken, required this.deviceService}) {
    dio = Dio(
      BaseOptions(
        baseUrl: '${AppConfig.baseUrl}/api',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        validateStatus: (status) => true,
        headers: {Headers.contentTypeHeader: Headers.jsonContentType},
      ),
    );

    // if (kDebugMode) {
    //   dio.interceptors.add(ChuckerDioInterceptor());
    // }
    dio.interceptors.add(
      ApiInterceptor(getToken: getToken, deviceService: deviceService),
    );
  }

  Map<String, String> _buildHeaders({Map<String, String>? customHeaders}) {
    return {...?customHeaders};
  }

  // =========================
  // GENERIC REQUEST
  // =========================
  Future<Map<String, dynamic>> _request(
    Future<Response> Function() requestFn,
  ) async {
    try {
      final response = await requestFn().timeout(const Duration(seconds: 15));
      return _handleResponse(response);
    } on TimeoutException {
      throw ApiException("Request timeout");
    } on DioException catch (e) {
      throw _mapDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException("$e");
    }
  }

  // =========================
  // POST
  // =========================
  Future<Map<String, dynamic>> postForm({
    required String path,
    required Map<String, dynamic> body,
    bool authRequired = true,
    Map<String, String>? headers,
  }) {
    return _request(
      () => dio.post(
        path,
        data: body,
        options: Options(
          headers: _buildHeaders(customHeaders: headers),
          extra: {'authRequired': authRequired},
        ),
      ),
    );
  }

  // =========================
  // GET
  // =========================
  Future<Map<String, dynamic>> getForm({
    required String path,
    bool authRequired = true,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) {
    return _request(
      () => dio.get(
        path,
        queryParameters: queryParams,
        options: Options(
          headers: _buildHeaders(customHeaders: headers),
          extra: {'authRequired': authRequired},
        ),
      ),
    );
  }

  // =========================
  // PUT
  // =========================
  Future<Map<String, dynamic>> putForm({
    required String path,
    required Map<String, dynamic> body,
    bool authRequired = true,
    Map<String, String>? headers,
  }) {
    return _request(
      () => dio.put(
        path,
        data: body,
        options: Options(
          headers: _buildHeaders(customHeaders: headers),
          extra: {'authRequired': authRequired},
        ),
      ),
    );
  }

  // =========================
  // DELETE
  // =========================
  Future<Map<String, dynamic>> deleteForm({
    required String path,
    bool authRequired = true,
    Map<String, String>? headers,
  }) {
    return _request(
      () => dio.delete(
        path,
        options: Options(
          headers: _buildHeaders(customHeaders: headers),
          extra: {'authRequired': authRequired},
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> postMultipart({
    required String path,
    required FormData formData,
    bool authRequired = true,
    Map<String, String>? headers,
  }) {
    return _request(
      () => dio.post(
        path,
        data: formData,
        options: Options(
          headers: {
            ..._buildHeaders(customHeaders: headers),
            Headers.contentTypeHeader: 'multipart/form-data',
          },
          extra: {'authRequired': authRequired},
        ),
      ),
    );
  }

  /// =========================
  /// DOWNLOAD FILE (UNTUK NOTIFICATION IMAGE)
  /// =========================
  Future<String> downloadFile({
    required String url,
    required String savePath,
  }) async {
    try {
      debugPrint("⬇️ DOWNLOAD FILE");
      debugPrint("➡️ URL: $url");
      debugPrint("➡️ SAVE PATH: $savePath");

      // await dio.download(
      //   url,
      //   savePath,
      //   options: Options(
      //     responseType: ResponseType.bytes,
      //     followRedirects: true,
      //     receiveTimeout: const Duration(seconds: 30),
      //   ),
      // );

      /// Separate Dio instance WITHOUT Chucker
      final downloadDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          followRedirects: true,
        ),
      );

      await downloadDio.download(
        url,
        savePath,
        options: Options(responseType: ResponseType.bytes),
      );

      debugPrint("✅ DOWNLOAD SUCCESS");
      return savePath;
    } on DioException catch (e) {
      debugPrint("❌ DOWNLOAD ERROR: ${e.message}");
      throw ApiException("Failed to download file");
    } catch (e) {
      debugPrint("❌ UNKNOWN DOWNLOAD ERROR: $e");
      throw ApiException("Unexpected download error");
    }
  }

  // =========================
  // RESPONSE HANDLER
  // =========================
  Map<String, dynamic> _handleResponse(Response response) {
    final statusCode = response.statusCode ?? 0;
    final data = response.data;

    if (statusCode >= 200 && statusCode < 300) {
      if (data is Map<String, dynamic>) {
        return data;
      }
      return {'data': data};
    }

    String message = 'Unexpected error';
    Map<String, dynamic>? errors;

    if (data is Map && data['message'] != null) {
      message = data['message'];
      if (data['errors'] != null) {
        final rawErrors = data['errors'];

        if (rawErrors is Map<String, dynamic>) {
          errors = rawErrors;
        } else if (rawErrors is Map) {
          errors = Map<String, dynamic>.from(rawErrors);
        }
      }
    }

    switch (statusCode) {
      case 400:
        // Sentry.captureException(BadRequestException(message, errors: errors));
        throw BadRequestException(message, errors: errors);

      case 401:
        // Sentry.captureException(UnauthorizedException(message, errors: errors));
        throw UnauthorizedException(message, errors: errors);

      case 403:
        // Sentry.captureException(ForbiddenException(message, errors: errors));
        throw ForbiddenException(message, errors: errors);

      case 404:
        // Sentry.captureException(NotFoundException(message, errors: errors));
        throw NotFoundException(message, errors: errors);

      case 500:
        // Sentry.captureException(ServerException(message, errors: errors));
        throw ServerException(message, errors: errors);

      default:
        // Sentry.captureException(
        //   ApiException('Server error [$statusCode]: $message \n$errors'),
        // );
        throw ApiException(message, errors: errors);
    }
  }

  Exception _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException("Request timed out");

      case DioExceptionType.connectionError:
        final message = e.message ?? '';

        if (message.contains('failed host lookup')) {
          return ApiException('No internet connection');
        }

        if (message.contains('connection refused')) {
          return ApiException('Server is down or unreachable');
        }

        if (message.contains('network is unreachable')) {
          return ApiException('No internet connection');
        }

        return ApiException('Connection error');

      case DioExceptionType.cancel:
        return ApiException('Request cancelled');

      default:
        final statusCode = e.response?.statusCode;

        if (statusCode == 401) {
          return ApiException('Session Expired');
        }

        final data = e.response?.data;

        if (data is Map && data['message'] != null) {
          return ApiException(data['message']);
        }

        return ApiException('Unexpected error occurred');
    }
  }
}

class ApiInterceptor extends Interceptor {
  final Future<String?> Function() getToken;
  final DeviceService deviceService;

  ApiInterceptor({required this.getToken, required this.deviceService});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final bool authRequired = options.extra['authRequired'] ?? true;

    if (authRequired) {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    final device = await deviceService.get();

    options.headers.addAll({
      'X-Device-Id': device.deviceId,
      'X-Platform': device.platform,
      'X-App-Version': device.appVersion,
      'X-Build-Number': device.buildNumber,
      'X-OS-Version': device.osVersion,
      'X-Device-Model': device.deviceModel,
    });

    debugPrint("🌍 REQUEST");
    debugPrint("➡️ BaseUrl: ${options.baseUrl}");
    debugPrint("➡️ Path: ${options.path}");
    debugPrint("➡️ Full URL: ${options.uri}");
    debugPrint("➡️ Method: ${options.method}");
    debugPrint("➡️ Headers: ${options.headers}");
    debugPrint("➡️ Query: ${options.queryParameters}");
    debugPrint("➡️ Body: ${options.data}");
    debugPrint("=====================================");

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      debugPrint("✅ RESPONSE");
      debugPrint("⬅️ URL: ${response.requestOptions.uri}");
      debugPrint("⬅️ StatusCode: ${response.statusCode}");
      if (response.requestOptions.responseType == ResponseType.bytes) {
        debugPrint("⬅️ Data: [BINARY DATA]");
      } else {
        debugPrint("⬅️ Data: ${response.data}");
      }
      debugPrint("=====================================");
      // await LocalNotificationService.showChuckerRequestNotification(
      //   method: response.requestOptions.method,
      //   statusCode: response.statusCode ?? 0,
      //   path: response.requestOptions.path,
      // );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      debugPrint("❌ ERROR");
      debugPrint("⬅️ URL: ${err.requestOptions.uri}");
      debugPrint("⬅️ StatusCode: ${err.response?.statusCode}");
      debugPrint("⬅️ Message: ${err.message}");
      debugPrint("⬅️ Data: ${err.response?.data}");
      debugPrint("=====================================");
    }

    try {
      final safeHeaders = err.requestOptions.headers.map(
        (key, value) => MapEntry(key, value.toString()),
      );
      safeHeaders.remove('Authorization');

      Map<String, dynamic>? safeBody;

      final data = err.requestOptions.data;

      if (data is Map<String, dynamic>) {
        safeBody = Map<String, dynamic>.from(data);
        safeBody.remove('password');
        safeBody.remove('token');
        safeBody.remove('refresh_token');
        safeBody.remove('pin');
        safeBody.remove('otp');
      }

      // await Sentry.captureException(
      //   err,
      //   stackTrace: err.stackTrace,
      //   withScope: (scope) {
      //     scope.setTag("type", "api_error");
      //     scope.setTag("client", "dio");
      //     scope.setContexts("request", {
      //       "url": err.requestOptions.uri.toString(),
      //       "method": err.requestOptions.method,
      //       "headers": safeHeaders,
      //       "query": err.requestOptions.queryParameters,
      //       "body": safeBody,
      //     });
      //     scope.setContexts("response", {
      //       "status_code": err.response?.statusCode,
      //       "data": err.response?.data,
      //     });
      //   },
      // );
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Sentry logging failed: $e");
      }
    }
    handler.next(err);
  }
}
