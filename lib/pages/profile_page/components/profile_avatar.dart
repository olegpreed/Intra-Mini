import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/components/default_avatar.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar(
      {super.key,
      required this.imageUrl,
      required this.isShimmerFinished,
      required this.isHomeView});
  final String? imageUrl;
  final bool isShimmerFinished;
  final bool isHomeView;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: !isShimmerFinished ? 0 : 1,
      child: imageUrl != null
          ? isHomeView
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const DefaultAvatar(),
                  fadeInDuration: const Duration(milliseconds: 300),
                )
              : Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    return const DefaultAvatar();
                  },
                )
          : const DefaultAvatar(),
    );
  }
}
