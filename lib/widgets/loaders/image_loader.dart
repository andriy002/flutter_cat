import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageLoader extends StatelessWidget {
  const ImageLoader({
    Key? key,
    required this.progress,
  }) : super(key: key);

  final DownloadProgress progress;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularProgressIndicator(
          value: progress.progress,
          strokeWidth: 3.0,
        ),
      ],
    );
  }
}
