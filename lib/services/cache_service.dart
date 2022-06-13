import 'dart:convert';

import 'package:flutter_cat/models/act_fact_model/cat_fact_model.dart';
import 'package:flutter_cat/models/cat_api_model/cat_favorite_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheServices {
  const CacheServices._();
  static const CacheServices instance = CacheServices._();

  static SharedPreferences? sharedPreference;

  Future<void> setInitState() async {
    sharedPreference = await SharedPreferences.getInstance();
  }

  bool isFirstSet(
    String isFirstSet,
  ) {
    if (sharedPreference!.getString(isFirstSet) != null) {
      return false;
    }

    sharedPreference!.setString(isFirstSet, 'false');

    return true;
  }

  Future<void> setElement({
    required String key,
    required Object value,
  }) async {
    await sharedPreference!.setString(
      key,
      jsonEncode(value),
    );
  }
}
