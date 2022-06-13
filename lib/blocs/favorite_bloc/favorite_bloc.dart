import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_cat/models/act_fact_model/cat_fact_model.dart';
import 'package:flutter_cat/models/act_fact_model/cat_fact_response_model.dart';
import 'package:flutter_cat/models/act_fact_model/pagination_model.dart';
import 'package:flutter_cat/models/cat_api_model/cat_favorite_image.dart';
import 'package:flutter_cat/models/cat_api_model/cat_favorite_image_response.dart';

import 'package:flutter_cat/models/cat_api_model/pagination_model.dart';
import 'package:flutter_cat/repositories/cat_api_repositories/cat_api_repositories.dart';
import 'package:flutter_cat/repositories/cat_fact_repositories/cat_fact_repositories.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class CatFavoriteImagesBloc
    extends Bloc<CatFavoriteImagesEvent, CatFavoriteImagesInitial> {
  CatFavoriteImagesBloc({
    required this.catImagesRepository,
    required this.catFactRepository,
  }) : super(const CatFavoriteImagesInitial()) {
    on<GetInitialList>(
      ((event, emit) async {
        if (await InternetConnectionChecker().hasConnection) {
          final CatFavoriteImagesResponseModel? responseCatFavoriteImage =
              await catImagesRepository.getFavoriteImages();

          final CatFactResponseModel? responseCatFact =
              await catFactRepository.getInitialCatFacts();

          if (responseCatFavoriteImage != null && responseCatFact != null) {
            emit(
              state.copyWith(
                status: BlocStatus.success,
                catImagesList: responseCatFavoriteImage.catImagesList,
                catFactsList: responseCatFact.catFactsList,
                paginationCatList: responseCatFavoriteImage.pagination,
                paginationCatFact: responseCatFact.pagination,
              ),
            );
          }
        } else {
          final sh = await SharedPreferences.getInstance();

          if (sh.getString('catFavoriteImages') != null &&
              sh.getString('factCat') != null) {
            final CatFavoriteImagesResponseModel catImagesList =
                CatFavoriteImagesResponseModel.fromJson(
                    (jsonDecode(sh.getString('catFavoriteImages')!) as List), {
              'pagination-count': ['0'],
              'pagination-page': ['0']
            });

            final CatFactResponseModel catFactsList =
                CatFactResponseModel.fromJson(
                    (jsonDecode(sh.getString('factCat')!) as List), {
              'total': 0,
              'current_page': 0,
            });

            emit(
              state.copyWith(
                status: BlocStatus.success,
                catImagesList: catImagesList.catImagesList,
                catFactsList: catFactsList.catFactsList,
                paginationCatList: const PaginationCatImageModel(),
              ),
            );
          } else {
            emit(
              state.copyWith(
                status: BlocStatus.success,
              ),
            );
          }
        }
      }),
    );

    on<GetFavoriteCatsList>((event, emit) async {
      final CatFavoriteImagesResponseModel? responseCatImagesList =
          await catImagesRepository.getFavoriteImages(
        page: event.loadMore ? state.paginationCatList.currentPage + 1 : 0,
      );

      final CatFactResponseModel? responseCatFact =
          await catFactRepository.getCatFacts(
        page: event.loadMore ? state.paginationCatFact.currentPage + 1 : 0,
      );

      if (responseCatImagesList != null && responseCatFact != null) {
        emit(
          state.copyWith(
              catImagesList: event.loadMore
                  ? [
                      ...state.catImagesList,
                      ...responseCatImagesList.catImagesList
                    ]
                  : [...responseCatImagesList.catImagesList],
              catFactsList: event.loadMore
                  ? [...state.catFactsList, ...responseCatFact.catFactsList]
                  : [...responseCatFact.catFactsList],
              paginationCatList: responseCatImagesList.pagination,
              paginationCatFact: state.paginationCatFact.totalRecords <=
                      state.catFactsList.length + 30
                  ? const PaginationCatFactModel(currentPage: 0)
                  : responseCatFact.pagination),
        );
      } else {
        emit(
          state.copyWith(
            status: BlocStatus.failed,
          ),
        );
      }
    });

    on<LikeCatImage>((event, emit) async {
      final response = await catImagesRepository.likeCatImage(
        imageId: event.imageId,
      );

      if (response != null) {
        final List<CatFavoriteImageModel> newList = [...state.catImagesList];

        newList[event.itemId] = state.catImagesList[event.itemId].copyWith(
          isLike: true,
          favoriteId: response,
        );

        emit(
          state.copyWith(
            catImagesList: newList,
          ),
        );
      }
    });

    on<DisLikeCatImage>((event, emit) async {
      final response = await catImagesRepository.dislike(
        favoriteId: event.favoriteId,
      );

      if (response != null) {
        final List<CatFavoriteImageModel> newList = [...state.catImagesList];

        newList[event.itemId] = state.catImagesList[event.itemId].copyWith(
          isLike: false,
        );

        emit(
          state.copyWith(
            catImagesList: newList,
          ),
        );
      }
    });
  }
  final CatApiRepository catImagesRepository;
  final CatFactRepository catFactRepository;
}
