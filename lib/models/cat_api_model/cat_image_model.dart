import 'package:flutter_cat/models/cat_api_model/cat_abstract_model.dart';

class CatImageModel implements CatImagesInterfaceModel {
  const CatImageModel({
    this.favoriteId = 0,
    this.isLike = false,
    required this.imageId,
    required this.imageUrl,
  });

  factory CatImageModel.fromJson(Map<String, dynamic> json) {
    return CatImageModel(
      imageId: json['id'],
      imageUrl: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': imageId,
        'url': imageUrl,
      };

  @override
  final int favoriteId;
  @override
  final String imageId;
  @override
  final String imageUrl;
  @override
  final bool isLike;

  @override
  CatImageModel copyWith({
    int? favoriteId,
    String? imageId,
    String? imageUrl,
    bool? isLike,
  }) {
    return CatImageModel(
      favoriteId: favoriteId ?? this.favoriteId,
      imageId: imageId ?? this.imageId,
      imageUrl: imageUrl ?? this.imageUrl,
      isLike: isLike ?? this.isLike,
    );
  }
}
