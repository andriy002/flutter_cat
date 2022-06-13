import 'package:flutter_cat/models/cat_api_model/cat_image_model.dart';
import 'package:flutter_cat/models/cat_api_model/pagination_model.dart';

class CatImagesResponseModel {
  const CatImagesResponseModel({
    required this.pagination,
    required this.catImagesList,
  });

  factory CatImagesResponseModel.fromJson(
      List<dynamic> json, Map<String, List<String>> jsonPagination) {
    return CatImagesResponseModel(
      pagination: PaginationCatImageModel.fromJson(jsonPagination),
      catImagesList: json.map((e) => CatImageModel.fromJson(e)).toList(),
    );
  }

  final PaginationCatImageModel? pagination;
  final List<CatImageModel> catImagesList;
}
