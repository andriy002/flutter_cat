part of 'favorite_bloc.dart';

@immutable
abstract class CatFavoriteImagesEvent {}

class GetInitialList extends CatFavoriteImagesEvent {}

class GetFavoriteCatsList extends CatFavoriteImagesEvent {
  GetFavoriteCatsList({
    required this.loadMore,
  });
  final bool loadMore;
}

class LikeCatImage extends CatFavoriteImagesEvent {
  LikeCatImage({
    required this.imageId,
    required this.itemId,
  });
  final String imageId;
  final int itemId;
}

class DisLikeCatImage extends CatFavoriteImagesEvent {
  DisLikeCatImage({
    required this.favoriteId,
    required this.itemId,
  });
  final int favoriteId;
  final int itemId;
}
