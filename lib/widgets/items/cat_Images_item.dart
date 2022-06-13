import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cat/models/cat_api_model/cat_abstract_model.dart';
import 'package:flutter_cat/resources/app_icons.dart';
import 'package:flutter_cat/widgets/loaders/image_loader.dart';
import 'package:flutter_cat/widgets/navigation/custom_app_bar.dart';
import 'package:flutter_cat/widgets/uncategorized/splash_box.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CatImagesItem extends StatefulWidget {
  const CatImagesItem({
    Key? key,
    this.checkIsLike,
    required this.catImage,
    required this.fact,
    required this.isLike,
    required this.index,
    required this.onTapLike,
    required this.onTapDisLike,
  }) : super(key: key);

  final CatImagesInterfaceModel catImage;
  final String fact;

  final bool isLike;
  final int index;
  final Function()? checkIsLike;
  final Function() onTapLike;
  final Function() onTapDisLike;

  @override
  State<CatImagesItem> createState() => _CatImagesItemState();
}

class _CatImagesItemState extends State<CatImagesItem> {
  bool _isHasConnection = false;

  @override
  void initState() {
    if (widget.checkIsLike != null) {
      widget.checkIsLike!();
    }
    _checkInternet();
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          transitionOnUserGestures: true,
          tag: widget.index,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                imageUrl: widget.catImage.imageUrl,
                progressIndicatorBuilder: (_, __, progress) => ImageLoader(
                  progress: progress,
                ),
              ),
            ),
          ),
        ),
        SplashBox(
          onTap: () async {
            await Navigator.of(
              context,
              rootNavigator: true,
            ).push(
              MaterialPageRoute(
                builder: (context) => _CatFacts(
                  args: _CatFactsArgument(
                    haConnection: _isHasConnection,
                    onTapDisLike: () => widget.onTapDisLike(),
                    onTapLike: widget.onTapLike,
                    index: widget.index,
                    catImage: widget.catImage,
                    fact: widget.fact,
                  ),
                ),
              ),
            );
          },
        ),
        if (_isHasConnection)
          GestureDetector(
            onTap: widget.isLike ? widget.onTapDisLike : widget.onTapLike,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: SvgPicture.asset(
                  AppIcons.heartIcon,
                  width: 30,
                  color: widget.isLike ? Colors.red : Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _CatFactsArgument {
  _CatFactsArgument({
    this.catImage,
    required this.index,
    required this.fact,
    required this.haConnection,
    required this.onTapLike,
    required this.onTapDisLike,
  });

  final CatImagesInterfaceModel? catImage;
  final int index;
  final String fact;
  final bool haConnection;

  final Function() onTapLike;
  final Function() onTapDisLike;
}

class _CatFacts extends StatefulWidget {
  const _CatFacts({
    Key? key,
    required this.args,
  }) : super(key: key);

  final _CatFactsArgument args;

  @override
  State<_CatFacts> createState() => _CatFactsState();
}

class _CatFactsState extends State<_CatFacts> {
  bool _isLike = false;

  @override
  void initState() {
    _isLike = widget.args.catImage!.isLike;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CustomAppBar(
        leading: const Icon(Icons.arrow_back),
        onLeading: () => Navigator.pop(context, _isLike),
        action: widget.args.haConnection
            ? SvgPicture.asset(
                AppIcons.heartIcon,
                color: _isLike ? Colors.red : Colors.white,
              )
            : null,
        onAction: () => setState(() {
          _isLike = !_isLike;

          !_isLike ? widget.args.onTapDisLike() : widget.args.onTapLike();
        }),
      ),
      body: Hero(
        transitionOnUserGestures: true,
        tag: widget.args.index,
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: size.height * 0.4,
                child: CachedNetworkImage(
                  imageUrl: widget.args.catImage!.imageUrl,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (_, __, progress) => ImageLoader(
                    progress: progress,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ).copyWith(
                  top: size.height * 0.5,
                ),
                child: Text(
                  widget.args.fact,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
