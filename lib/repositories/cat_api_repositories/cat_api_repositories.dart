import 'package:dio/dio.dart';
import 'package:flutter_cat/models/cat_api_model/cat_favorite_image_response.dart';
import 'package:flutter_cat/models/cat_api_model/cat_image_response_model.dart';
import 'package:flutter_cat/models/user_model/user_model.dart';
import 'package:flutter_cat/repositories/cat_api_repositories/base_repositories.dart';
import 'package:flutter_cat/services/cache_service.dart';

class CatApiRepository {
  static final BaseCatApiRepository _baseRepository = BaseCatApiRepository();
  static final Dio _api = _baseRepository.api;

  Future<CatImagesResponseModel?> getCatImages({
    int page = 0,
    int size = 10,
  }) async {
    final Response response = await _api.get(
      '/images/search',
      queryParameters: {
        'limit': size,
        'page': page,
        'order': 'Desc.',
      },
    );

    if (response.statusCode == 200) {
      if (CacheServices.instance.isFirstSet('setCatImages')) {
        CacheServices.instance.setElement(
          key: 'catImages',
          value: response.data,
        );
      }
      return CatImagesResponseModel.fromJson(
        response.data,
        response.headers.map,
      );
    }

    return null;
  }

  Future<CatFavoriteImagesResponseModel?> getFavoriteImages({
    int page = 0,
    int size = 10,
  }) async {
    final UserModel? user = await CacheServices.instance.getUser();

    final Response response = await _api.get(
      '/favourites',
      queryParameters: {
        'sub_id': user?.uid,
        'limit': size,
        'page': page,
      },
    );

    if (response.statusCode == 200) {
      if ((response.data as List).length == 10) {
        if (CacheServices.instance.isFirstSet('setFavoriteImages')) {
          CacheServices.instance.setElement(
            key: 'catFavoriteImages',
            value: response.data,
          );
        }
      }
      return CatFavoriteImagesResponseModel.fromJson(
          response.data, response.headers.map);
    }

    return null;
  }

  Future<int?> likeCatImage({required imageId}) async {
    final UserModel? user = await CacheServices.instance.getUser();

    final Response response = await _api.post(
      '/favourites',
      data: {
        'image_id': imageId,
        'sub_id': user?.uid,
      },
    );

    if (response.statusCode == 200) {
      return response.data['id'];
    }

    return null;
  }

  Future<bool?> dislike({
    required favoriteId,
  }) async {
    final Response response = await _api.delete(
      '/favourites/$favoriteId',
    );

    if (response.statusCode == 200) {
      return true;
    }

    return null;
  }
}
