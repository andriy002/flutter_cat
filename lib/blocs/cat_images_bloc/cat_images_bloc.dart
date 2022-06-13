import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_cat/models/act_fact_model/cat_fact_model.dart';
import 'package:flutter_cat/models/act_fact_model/cat_fact_response_model.dart';
import 'package:flutter_cat/models/act_fact_model/pagination_model.dart';
import 'package:flutter_cat/models/cat_api_model/cat_favorite_image.dart';
import 'package:flutter_cat/models/cat_api_model/cat_image_model.dart';
import 'package:flutter_cat/models/cat_api_model/cat_image_response_model.dart';
import 'package:flutter_cat/models/cat_api_model/pagination_model.dart';
import 'package:flutter_cat/repositories/cat_api_repositories/cat_api_repositories.dart';
import 'package:flutter_cat/repositories/cat_fact_repositories/cat_fact_repositories.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cat_images_event.dart';
part 'cat_images_state.dart';

class CatImagesBloc extends Bloc<CatImagesEvent, CatImagesInitial> {
  CatImagesBloc({
    required this.catImagesRepository,
    required this.catFactRepository,
  }) : super(const CatImagesInitial()) {
    on<GetInitialList>(
      ((event, emit) async {
        if (await InternetConnectionChecker().hasConnection) {
          final CatImagesResponseModel? responseCatImage =
              await catImagesRepository.getCatImages();

          final CatFactResponseModel? responseCatFact =
              await catFactRepository.getInitialCatFacts();

          if (responseCatImage != null && responseCatFact != null) {
            emit(
              state.copyWith(
                status: BlocStatus.success,
                catImagesList: responseCatImage.catImagesList,
                catFactsList: responseCatFact.catFactsList,
                paginationCatImage: responseCatImage.pagination,
                paginationCatFact: responseCatFact.pagination,
              ),
            );
          }
        } else {
          final sh = await SharedPreferences.getInstance();

          if (sh.getString('catImages') != null &&
              sh.getString('factCat') != null) {
            final CatImagesResponseModel? catImagesList =
                CatImagesResponseModel.fromJson(
                    (jsonDecode(sh.getString('catImages')!) as List), {
              'pagination-count': ['0'],
              'pagination-page': ['0']
            });

            final CatFactResponseModel? catFactsList =
                CatFactResponseModel.fromJson(
                    (jsonDecode(sh.getString('factCat')!) as List), {
              'total': 0,
              'current_page': 0,
            });

            emit(
              state.copyWith(
                status: BlocStatus.success,
                catImagesList: catImagesList?.catImagesList ?? [],
                catFactsList: catFactsList?.catFactsList ?? [],
                paginationCatImage: catImagesList?.pagination ??
                    const PaginationCatImageModel(),
              ),
            );
          } else {
            emit(state.copyWith(
              status: BlocStatus.success,
            ));
          }
        }
      }),
    );

    on<GetPaginationList>((event, emit) async {
      final CatImagesResponseModel? responseCatImages =
          await catImagesRepository.getCatImages(
        page: event.loadMore ? state.paginationCatImage.currentPage + 1 : 0,
      );

      final CatFactResponseModel? responseCatFact =
          await catFactRepository.getCatFacts(
        page: event.loadMore ? state.paginationCatFact.currentPage + 1 : 0,
      );

      if (responseCatImages != null && responseCatFact != null) {
        emit(
          state.copyWith(
            catImagesList: event.loadMore
                ? [...state.catImagesList, ...responseCatImages.catImagesList]
                : [...responseCatImages.catImagesList],
            paginationCatImage: responseCatImages.pagination,
            catFactsList: event.loadMore
                ? [...state.catFactsList, ...responseCatFact.catFactsList]
                : [...responseCatFact.catFactsList],
            paginationCatFact: state.paginationCatFact.totalRecords <=
                    state.catFactsList.length + 30
                ? const PaginationCatFactModel(currentPage: 0)
                : responseCatFact.pagination,
          ),
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
        final List<CatImageModel> newList = [...state.catImagesList];

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
        final List<CatImageModel> newList = [...state.catImagesList];

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

    on<SetFavoriteId>((event, emit) async {
      final List<CatImageModel> newList = [...state.catImagesList];

      newList[event.itemId] = state.catImagesList[event.itemId].copyWith(
        favoriteId: state.catFavoriteList[event.favoriteId].favoriteId,
        isLike: true,
      );

      emit(state.copyWith(
        catImagesList: newList,
      ));
    });
  }
  final CatApiRepository catImagesRepository;
  final CatFactRepository catFactRepository;
}
