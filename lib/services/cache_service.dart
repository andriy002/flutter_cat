import 'dart:convert';
import 'package:flutter_cat/models/act_fact_model/cat_fact_response_model.dart';
import 'package:flutter_cat/models/cat_api_model/cat_favorite_image_response.dart';
import 'package:flutter_cat/models/cat_api_model/cat_image_response_model.dart';
import 'package:flutter_cat/models/user_model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheServices {
  const CacheServices._();
  static const CacheServices instance = CacheServices._();

  static SharedPreferences? _sharedPreference;

  Future<void> setInitState() async {
    _sharedPreference = await SharedPreferences.getInstance();
  }

  bool isFirstSet(
    String isFirstSet,
  ) {
    if (_sharedPreference!.getString(isFirstSet) != null) {
      return false;
    }

    _sharedPreference!.setString(isFirstSet, 'false');

    return true;
  }

  Future<void> setElement({
    required String key,
    required Object value,
  }) async {
    await _sharedPreference!.setString(
      key,
      jsonEncode(value),
    );
  }

  Future<UserModel?> getUser() async {
    if (_sharedPreference!.getString('profile') != null) {
      final userJson =
          await jsonDecode(_sharedPreference!.getString('profile')!);
      final UserModel user = UserModel.fromJson(userJson);

      return user;
    }
    return null;
  }

  Future<CatImagesResponseModel?> getCatApiCacheList() async {
    if (_sharedPreference!.getString('catImages') != null) {
      final CatImagesResponseModel? catImagesList =
          CatImagesResponseModel.fromJson(
        (jsonDecode(_sharedPreference!.getString('catImages')!) as List),
        {
          'pagination-count': ['0'],
          'pagination-page': ['0']
        },
      );

      return catImagesList;
    }

    return null;
  }

  Future<CatFactResponseModel?> getCatFactApiCacheList() async {
    if (_sharedPreference!.getString('factCat') != null) {
      final CatFactResponseModel? catFactsList = CatFactResponseModel.fromJson(
          (jsonDecode(_sharedPreference!.getString('factCat')!) as List), {
        'total': 0,
        'current_page': 0,
      });

      return catFactsList;
    }

    return null;
  }

  Future<CatFavoriteImagesResponseModel?>
      getCatApiFavoriteImagesCacheList() async {
    if (_sharedPreference!.getString('catFavoriteImages') != null) {
      final CatFavoriteImagesResponseModel catImagesList =
          CatFavoriteImagesResponseModel.fromJson(
              (jsonDecode(_sharedPreference!.getString('catFavoriteImages')!)
                  as List),
              {
            'pagination-count': ['0'],
            'pagination-page': ['0']
          });
      return catImagesList;
    }

    return null;
  }
}
