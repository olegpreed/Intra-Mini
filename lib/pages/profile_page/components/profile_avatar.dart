import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/components/default_avatar.dart';
import 'package:fullscreen_image_viewer/fullscreen_image_viewer.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(
      {super.key, required this.imageUrl, required this.isHomeView});
  final String? imageUrl;
  final bool isHomeView;

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? isHomeView
            ? FullscreenViewerWrapper(
                heroTag: imageUrl!,
                child: CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const DefaultAvatar(),
                  fadeInDuration: const Duration(milliseconds: 300),
                ),
              )
            : FullscreenViewerWrapper(
                heroTag: imageUrl!,
                child: FadeInImage.memoryNetwork(
                  placeholder: kTransparentImage,
                  image: imageUrl!,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return const DefaultAvatar();
                  },
                ),
              )
        : const DefaultAvatar();
  }
}
