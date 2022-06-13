part of 'cat_images_bloc.dart';

@immutable
abstract class CatImagesEvent {}

class GetInitialList extends CatImagesEvent {}

class GetPaginationList extends CatImagesEvent {
  GetPaginationList({
    required this.loadMore,
  });
  final bool loadMore;
}

class LikeCatImage extends CatImagesEvent {
  LikeCatImage({
    required this.imageId,
    required this.itemId,
  });
  final String imageId;
  final int itemId;
}

class DisLikeCatImage extends CatImagesEvent {
  DisLikeCatImage({
    required this.favoriteId,
    required this.itemId,
  });
  final int favoriteId;
  final int itemId;
}

class SetFavoriteId extends CatImagesEvent {
  SetFavoriteId({
    required this.favoriteId,
    required this.itemId,
  });

  final int favoriteId;
  final int itemId;
}
