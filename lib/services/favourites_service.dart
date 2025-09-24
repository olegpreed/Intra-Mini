import 'package:shared_preferences/shared_preferences.dart';

class FavouriteStorage {
  static String _keyForUser(String userId) => 'favourite_users_$userId';

  static Future<void> saveFavourites(String userId, List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyForUser(userId), ids);
  }

  static Future<List<String>> loadFavourites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyForUser(userId)) ?? [];
  }

  static Future<void> addFavourite(String userId, String id) async {
    final favs = await loadFavourites(userId);
    if (!favs.contains(id)) {
      favs.add(id);
      await saveFavourites(userId, favs);
    }
  }

  static Future<void> removeFavourite(String userId, String id) async {
    final favs = await loadFavourites(userId);
    favs.remove(id);
    await saveFavourites(userId, favs);
  }

  static Future<bool> isFavourite(String userId, String id) async {
    final favs = await loadFavourites(userId);
    return favs.contains(id);
  }
}
