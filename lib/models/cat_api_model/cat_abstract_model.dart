class CatImagesInterfaceModel {
  CatImagesInterfaceModel({
    required this.favoriteId,
    required this.imageId,
    required this.imageUrl,
    required this.isLike,
  });

  final int favoriteId;
  final String imageId;
  final String imageUrl;
  final bool isLike;

  CatImagesInterfaceModel copyWith({
    int? favoriteId,
    String? imageId,
    String? imageUrl,
    bool? isLike,
  }) {
    return CatImagesInterfaceModel(
      favoriteId: favoriteId ?? this.favoriteId,
      imageId: imageId ?? this.imageId,
      imageUrl: imageUrl ?? this.imageUrl,
      isLike: isLike ?? this.isLike,
    );
  }
}
