import 'package:flutter_cat/models/act_fact_model/cat_fact_model.dart';
import 'package:flutter_cat/models/act_fact_model/pagination_model.dart';

class CatFactResponseModel {
  const CatFactResponseModel({
    required this.pagination,
    required this.catFactsList,
  });

  factory CatFactResponseModel.fromJson(
      List<dynamic> json, Map<String, dynamic> jsonPagination) {
    return CatFactResponseModel(
      pagination: PaginationCatFactModel.fromJson(jsonPagination),
      catFactsList: json.map((e) => CatFactModel.fromJson(e)).toList(),
    );
  }

  final PaginationCatFactModel pagination;
  final List<CatFactModel> catFactsList;
}
