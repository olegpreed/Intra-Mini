import 'package:flutter_svg/flutter_svg.dart';

Future precacheSvgPictures(List<String> svgPaths) async {
  for (final svgPath in svgPaths) {
    final logo = SvgAssetLoader(svgPath);
    await svg.cache
        .putIfAbsent(logo.cacheKey(null), () => logo.loadBytes(null));
  }
}