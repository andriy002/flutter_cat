part of 'cat_images_bloc.dart';

class CatImagesInitial {
  const CatImagesInitial(
      {this.status = BlocStatus.initial,
      this.catImagesList = const [],
      this.catFactsList = const [],
      this.catFavoriteList = const [],
      this.paginationCatImage = const PaginationCatImageModel(),
      this.paginationCatFact = const PaginationCatFactModel()});

  final BlocStatus status;
  final List<CatImageModel> catImagesList;
  final List<CatFactModel> catFactsList;
  final List<CatFavoriteImageModel> catFavoriteList;
  final PaginationCatImageModel paginationCatImage;
  final PaginationCatFactModel paginationCatFact;

  CatImagesInitial copyWith({
    BlocStatus? status,
    List<CatImageModel>? catImagesList,
    List<CatFactModel>? catFactsList,
    List<CatFavoriteImageModel>? catFavoriteList,
    PaginationCatImageModel? paginationCatImage,
    PaginationCatFactModel? paginationCatFact,
  }) {
    return CatImagesInitial(
      status: status ?? this.status,
      catImagesList: catImagesList ?? this.catImagesList,
      catFactsList: catFactsList ?? this.catFactsList,
      catFavoriteList: catFavoriteList ?? this.catFavoriteList,
      paginationCatImage: paginationCatImage ?? this.paginationCatImage,
      paginationCatFact: paginationCatFact ?? this.paginationCatFact,
    );
  }
}
