import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cat/blocs/cat_images_bloc/cat_images_bloc.dart';
import 'package:flutter_cat/models/cat_api_model/cat_favorite_image.dart';
import 'package:flutter_cat/models/cat_api_model/cat_image_model.dart';
import 'package:flutter_cat/repositories/cat_api_repositories/cat_api_repositories.dart';
import 'package:flutter_cat/repositories/cat_fact_repositories/cat_fact_repositories.dart';
import 'package:flutter_cat/utils/constants.dart';
import 'package:flutter_cat/widgets/items/cat_Images_item.dart';
import 'package:flutter_cat/widgets/navigation/custom_app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _onLoading(BuildContext context) async {
    context.read<CatImagesBloc>().add(
          GetPaginationList(
            loadMore: true,
          ),
        );
  }

  void _checkIsLike({
    required List<CatImageModel> catImageList,
    required List<CatFavoriteImageModel> catFavoriteImage,
    required int index,
    required BuildContext context,
  }) {
    final int i = catFavoriteImage
        .indexWhere((e) => e.imageId == catImageList[index].imageId);

    if (i != -1) {
      context.read<CatImagesBloc>().add(
            SetFavoriteId(
              favoriteId: i,
              itemId: index,
            ),
          );
    }
  }

  void _likeCatImage(
      {required BuildContext context,
      required String imageId,
      required int itemId}) {
    context.read<CatImagesBloc>().add(
          LikeCatImage(
            itemId: itemId,
            imageId: imageId,
          ),
        );
  }

  void _disLikeCatImage(
      {required BuildContext context,
      required int favoriteId,
      required int itemId}) {
    context.read<CatImagesBloc>().add(
          DisLikeCatImage(
            itemId: itemId,
            favoriteId: favoriteId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Cats'),
      ),
      body: BlocProvider<CatImagesBloc>(
        create: (context) => CatImagesBloc(
          catImagesRepository: context.read<CatApiRepository>(),
          catFactRepository: context.read<CatFactRepository>(),
        )..add(
            GetInitialList(),
          ),
        child: BlocConsumer<CatImagesBloc, CatImagesInitial>(
          listener: (_, state) {
            if (state.paginationCatImage.totalRecords <=
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
                                checkIsLike: () => _checkIsLike(
                                  catFavoriteImage: state.catFavoriteList,
                                  catImageList: state.catImagesList,
                                  index: i,
                                  context: context,
                                ),
                                isLike: state.catImagesList[i].isLike,
                                onTapLike: () => _likeCatImage(
                                  context: context,
                                  imageId: state.catImagesList[i].imageId,
                                  itemId: i,
                                ),
                                onTapDisLike: () => _disLikeCatImage(
                                  context: context,
                                  itemId: i,
                                  favoriteId: state.catImagesList[i].favoriteId,
                                ),
                              );
                            },
                            itemCount: state.catImagesList.length,
                          )
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
