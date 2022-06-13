import 'package:dio/dio.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseCatApiRepository {
  BaseCatApiRepository() {
    api = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        validateStatus: (_) => true,
      ),
    );

    api.interceptors.addAll([
      PrettyDioLogger(
        requestBody: true,
      ),
      InterceptorsWrapper(
        onRequest: (RequestOptions options, handler) async {
          options.headers['x-api-key'] = kCatImagesApiKey;

          return handler.next(options);
        },
        onError: (DioError error, handler) {
          return handler.next(error);
        },
      ),
    ]);
  }
  final String baseUrl = kCatApiBaseRepo;
  late final Dio api;
}
