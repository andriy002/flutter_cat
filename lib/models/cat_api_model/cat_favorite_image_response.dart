import 'package:flutter_cat/models/cat_api_model/cat_favorite_image.dart';
import 'package:flutter_cat/models/cat_api_model/pagination_model.dart';

class CatFavoriteImagesResponseModel {
  const CatFavoriteImagesResponseModel({
    required this.pagination,
    required this.catImagesList,
  });

  factory CatFavoriteImagesResponseModel.fromJson(
      List<dynamic> json, Map<String, List<String>> jsonPagination) {
    return CatFavoriteImagesResponseModel(
      pagination: PaginationCatImageModel.fromJson(jsonPagination),
      catImagesList:
          json.map((e) => CatFavoriteImageModel.fromJson(e)).toList(),
    );
  }

  final PaginationCatImageModel pagination;
  final List<CatFavoriteImageModel> catImagesList;
}
