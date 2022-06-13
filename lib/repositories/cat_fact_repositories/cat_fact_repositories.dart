import 'package:dio/dio.dart';
import 'package:flutter_cat/models/act_fact_model/cat_fact_response_model.dart';
import 'package:flutter_cat/repositories/cat_fact_repositories/base_repositories.dart';
import 'package:flutter_cat/services/cache_service.dart';

class CatFactRepository {
  static final BaseCatFactApiRepository _baseRepository =
      BaseCatFactApiRepository();
  static final Dio _api = _baseRepository.api;

  Future<CatFactResponseModel?> getInitialCatFacts({
    int size = 10,
  }) async {
    final Response response = await _api.get(
      'facts',
      queryParameters: {
        'limit': size,
      },
    );

    if (response.statusCode == 200) {
      if (CacheServices.instance.isFirstSet('setCatFacts')) {
        CacheServices.instance.setElement(
          key: 'factCat',
          value: response.data['data'],
        );
      }
      return CatFactResponseModel.fromJson(
        response.data['data'],
        response.data,
      );
    }
  }

  Future<CatFactResponseModel?> getCatFacts({
    int page = 10,
  }) async {
    final Response response = await _api.get(
      'facts',
      queryParameters: {
        'page': page,
      },
    );

    if (response.statusCode == 200) {
      return CatFactResponseModel.fromJson(
        response.data['data'],
        response.data,
      );
    }
    return null;
  }
}
