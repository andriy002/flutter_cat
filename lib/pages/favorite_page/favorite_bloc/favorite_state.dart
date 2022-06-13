part of 'favorite_bloc.dart';

class CatFavoriteImagesInitial {
  const CatFavoriteImagesInitial({
    this.status = BlocStatus.initial,
    this.catImagesList = const [],
    this.catFactsList = const [],
    this.paginationCatList = const PaginationCatImageModel(),
    this.paginationCatFact = const PaginationCatFactModel(),
  });

  final BlocStatus status;
  final List<CatFavoriteImageModel> catImagesList;
  final List<CatFactModel> catFactsList;
  final PaginationCatImageModel paginationCatList;
  final PaginationCatFactModel paginationCatFact;

  CatFavoriteImagesInitial copyWith({
    BlocStatus? status,
    List<CatFavoriteImageModel>? catImagesList,
    List<CatFactModel>? catFactsList,
    PaginationCatImageModel? paginationCatList,
    PaginationCatFactModel? paginationCatFact,
  }) {
    return CatFavoriteImagesInitial(
      status: status ?? this.status,
      catImagesList: catImagesList ?? this.catImagesList,
      catFactsList: catFactsList ?? this.catFactsList,
      paginationCatList: paginationCatList ?? this.paginationCatList,
      paginationCatFact: paginationCatFact ?? this.paginationCatFact,
    );
  }
}
