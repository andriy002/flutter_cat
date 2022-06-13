import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat/repositories/cat_api_repositories/cat_api_repositories.dart';
import 'package:flutter_cat/repositories/cat_fact_repositories/cat_fact_repositories.dart';
import 'package:flutter_cat/repositories/firebase_repositories/firestore_repositories.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:flutter_cat/widgets/items/cat_Images_item.dart';
import 'package:flutter_cat/widgets/navigation/custom_app_bar.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'favorite_bloc/favorite_bloc.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  static const routeName = '/favorite_page';

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final RefreshController _refreshController = RefreshController();
  bool _isHasConnection = true;

  @override
  void initState() {
    if (mounted) {
      _checkInternet();
    }
    super.initState();
  }

  Future<void> _checkInternet() async {
    if (await InternetConnectionChecker().hasConnection) {
      setState(() {
        _isHasConnection = true;
      });
    } else {
      setState(() {
        _isHasConnection = false;
      });
    }
  }

  void _disLikeCatImage({
    required BuildContext context,
    required int favoriteId,
    required int itemId,
    required String imageId,
  }) {
    context.read<CatFavoriteImagesBloc>().add(
          DisLikeCatImage(
            itemId: itemId,
            favoriteId: favoriteId,
            imageId: imageId,
          ),
        );
  }

  Future<void> _onLoading(BuildContext context) async {
    context.read<CatFavoriteImagesBloc>().add(
          GetFavoriteCatsList(
            loadMore: true,
          ),
        );
  }

  void _likeCatImage(
      {required BuildContext context,
      required String imageId,
      required int itemId}) {
    context.read<CatFavoriteImagesBloc>().add(
          LikeCatImage(
            itemId: itemId,
            imageId: imageId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Favorite cats'),
      ),
      body: BlocProvider<CatFavoriteImagesBloc>(
        create: (context) => CatFavoriteImagesBloc(
            catImagesRepository: context.read<CatApiRepository>(),
            catFactRepository: context.read<CatFactRepository>(),
            firestoreRepositories: context.read<FirestoreRepositories>())
          ..add(
            GetInitialList(),
          ),
        child: BlocConsumer<CatFavoriteImagesBloc, CatFavoriteImagesInitial>(
          listener: (_, state) {
            _refreshController.loadComplete();
            if (state.paginationCatList.totalRecords <=
                state.catImagesList.length) {
              _refreshController.loadNoData();
            } else if (state.status == BlocStatus.success) {
              _refreshController.loadComplete();
            }
          },
          builder: (context, state) {
            return state.status == BlocStatus.success
                ? SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    enablePullDown: false,
                    onLoading: () => _onLoading(context),
                    child: state.catImagesList.isNotEmpty
                        ? GridView.builder(
                            padding: const EdgeInsets.all(
                              8.0,
                            ),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, i) {
                              return CatImagesItem(
                                index: i,
                                catImage: state.catImagesList[i],
                                fact: state.catFactsList[i].fact,
                                isLike: state.catImagesList[i].isLike,
                                onTapLike: () => _likeCatImage(
                                  context: context,
                                  imageId: state.catImagesList[i].imageId,
                                  itemId: i,
                                ),
                                onTapDisLike: () => _disLikeCatImage(
                                  context: context,
                                  imageId: state.catImagesList[i].imageId,
                                  itemId: i,
                                  favoriteId: state.catImagesList[i].favoriteId,
                                ),
                              );
                            },
                            itemCount: state.catImagesList.length,
                          )
                        : _isHasConnection
                            ? const SizedBox()
                            : const Center(
                                child: Text(
                                  'No internet connection',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                ),
                              ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }
}
