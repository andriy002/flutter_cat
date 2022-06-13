import 'package:flutter_cat/models/cat_api_model/cat_abstract_model.dart';

class CatFavoriteImageModel implements CatImagesInterfaceModel {
  const CatFavoriteImageModel({
    required this.favoriteId,
    required this.imageId,
    required this.imageUrl,
    this.isLike = true,
  });

  factory CatFavoriteImageModel.fromJson(Map<String, dynamic> json) {
    return CatFavoriteImageModel(
      imageId: json['image_id'],
      imageUrl: json['image']['url'],
      favoriteId: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'image_id': imageId,
        'image:': '{"url": $imageUrl}',
        'id': favoriteId,
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
  CatFavoriteImageModel copyWith({
    int? favoriteId,
    String? imageId,
    String? imageUrl,
    bool? isLike,
  }) {
    return CatFavoriteImageModel(
      favoriteId: favoriteId ?? this.favoriteId,
      imageId: imageId ?? this.imageId,
      imageUrl: imageUrl ?? this.imageUrl,
      isLike: isLike ?? this.isLike,
    );
  }
}
