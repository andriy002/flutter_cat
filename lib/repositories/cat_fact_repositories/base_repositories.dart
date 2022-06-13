import 'package:dio/dio.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class BaseCatFactApiRepository {
  BaseCatFactApiRepository() {
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
    ]);
  }
  final String baseUrl = kCatFactBaseRepo;
  late final Dio api;
}
