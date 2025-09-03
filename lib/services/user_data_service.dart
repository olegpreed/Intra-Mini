import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/data/project_ids.dart';
import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/logger_service.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:forty_two_planet/utils/class_utils.dart';
import 'package:forty_two_planet/utils/date_utils.dart';
import 'package:forty_two_planet/utils/http_utils.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Campus {
  int? id;
  String? name;
  int? usersCount;
  String? city;
  String? country;
  String? website;
  DateTime? enrollmentDate;
  bool? isActive;
}

class UserData {
  int? id;
  String? login;
  String firstName = '';
  String lastName = '';
  Map<int, double> cursusLevels = {};
  Map<int, String> cursusNames = {};
  String? imageUrlSmall;
  String? imageUrlBig;
  int wallet = 0;
  int evalPoints = 0;
  String? location;
  Color? coalitionColor;
  List<Campus> campuses = [];
  int? currentCampusId;
  DateTime? lastSeen;
  String? poolMonth;
  String? poolYear;
  bool? isActive;
  bool? isStaff;
  Map<int, List<ProjectData>> projectsByCursusId = {};
  Map<String, double> skills = {};
  UserData({this.login});
  Map<DateTime, List<Pair<Duration, Duration>>> weeklyLogTimesByMonth = {};
}

class SearchProjectData {
  int? teamId;
  String? teamName;
  DateTime? timeStamp;
  int? finalMark;
  bool? isFailed;
}

class ProjectData {
  int? projectId;
  String? name;
  String? status;
  bool? validated;
  DateTime? timeStamp;
  int? finalMark;
}

class TeamData {
  int? id;
  String? name;
  int? finalMark;
  bool? isFailed;
  Map<String, bool> members = {};
}

class FeedbackData {
  int mark = 0;
  String corrector = '';
  String comment = '';
  String feedback = '';
  bool isFailed = false;
  DateTime time = DateTime.now();
}

class Slot {
  List<int> ids;
  bool isBooked;
  bool isInvisible;
  List<String> bookedBy;
  String? projectName;
  DateTime? beginAt;
  DateTime? endAt;

  Slot({
    this.ids = const [],
    this.isBooked = false,
    this.isInvisible = false,
    this.bookedBy = const [],
    this.projectName,
    this.beginAt,
    this.endAt,
  });

  @override
  String toString() {
    return 'Slot: $beginAt - $endAt (booked: $isBooked) (invisible: $isInvisible) (project: $projectName) (bookedBy: $bookedBy)';
  }
}

class MyProfileStore extends ChangeNotifier {
  UserData userData = UserData();
  Map<int, int> eventIds = {};
  List<Slot> slots = [];

  void setProfile(UserData fetchedUserData) {
    userData = fetchedUserData;
    notifyListeners();
  }

  void setSlots(List<Slot> fetchedSlots) {
    slots = fetchedSlots;
    notifyListeners();
  }

  void setEventIds(Map<int, int> newEventIds) {
    eventIds = Map.from(newEventIds);
    notifyListeners();
  }

  static Future<void> saveMyCoalitionColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('myCoalition', color.value);
  }

  static Future<Color?> getCoalitionColor() async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('myCoalition');
    return colorValue != null ? Color(colorValue) : null;
  }

  static Future<void> saveMyProfileImage(String imageUrl) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileExtension = imageUrl.split('.').last;
      final filePath = '${directory.path}/avatar.$fileExtension';

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      logger.e('Error saving image: $e');
    }
  }

  static Future<ImageProvider?> loadProfileImage(String imageUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileExtension = imageUrl.split('.').last;
    final filePath = '${directory.path}/avatar.$fileExtension';

    final file = File(filePath);
    if (await file.exists()) {
      return FileImage(file);
    }
    return null;
  }

  static Future<void> deleteProfileImage(String imageUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileExtension = imageUrl.split('.').last;
    final filePath = '${directory.path}/avatar.$fileExtension';

    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }
}

class UserService {
  static Future<void> deleteSlot(Slot slot) async {
    for (var id in slot.ids) {
      await requestWithRetry(
          HttpMethod.delete, createUri(endpoint: '/slots/$id'), false);
    }
  }

  static Future<void> putSlot(
      int userId, DateTime beginAt, DateTime endAt) async {
    String startTime = beginAt.toUtc().toIso8601String();
    String endTime = endAt.toUtc().toIso8601String();
    await requestWithRetry(
        HttpMethod.post,
        createUri(endpoint: '/slots', queryParameters: {
          'slot[user_id]': userId.toString(),
          'slot[begin_at]': startTime,
          'slot[end_at]': endTime,
        }),
        false);
  }

  static List<Slot> combineAdjacentSlots(List<Slot> slots) {
    if (slots.isEmpty) return slots;

    List<Slot> combinedSlots = [];
    Slot? currentSlot;

    for (var slot in slots) {
      if (currentSlot == null) {
        currentSlot = slot;
      } else if (currentSlot.isBooked == slot.isBooked &&
          currentSlot.endAt == slot.beginAt) {
        currentSlot.endAt = slot.endAt;
        currentSlot.ids.addAll(slot.ids);
      } else {
        combinedSlots.add(currentSlot);
        currentSlot = slot;
      }
    }

    if (currentSlot != null) {
      combinedSlots.add(currentSlot);
    }

    return combinedSlots;
  }

  static void convertSlotsToLocal(List<Slot> allCombinedSlots) {
    for (var slot in allCombinedSlots) {
      if (slot.beginAt != null) {
        slot.beginAt = slot.beginAt!.toLocal();
      }
      if (slot.endAt != null) {
        slot.endAt = slot.endAt!.toLocal();
      }
    }
  }

  static Future<String> fetchProjectName(int scaleId) async {
    int projectId;
    try {
      final response = await requestWithRetry(
          HttpMethod.get,
          createUri(endpoint: 'me/scale_teams', queryParameters: {
            'filter[scale_id]': '$scaleId',
          }),
          false);
      if (response.statusCode == 200) {
        projectId = json.decode(response.body)[0]['team']['project_id'];
        return projectsByIds.entries
            .firstWhere(
              (element) => element.value == projectId,
              orElse: () => const MapEntry<String, int>('Unknown', -1),
            )
            .key;
      }
    } catch (e) {
      return 'Unknown';
    }
    return 'Unknown';
  }

  static Future<List<Slot>> fetchSlots() async {
    List<Slot> allSlots = [];
    String sort = 'begin_at';
    int pageSize = 100;
    int pageNumber = 1;
    int totalPages = 1;
    while (pageNumber <= totalPages) {
      final response = await requestWithRetry(
          HttpMethod.get,
          createUri(endpoint: '/me/slots', queryParameters: {
            'sort': sort,
            'page[size]': '$pageSize',
            'page[number]': '$pageNumber',
            'filter[future]': 'true',
          }),
          false);

      List<dynamic> slots = json.decode(response.body);
      for (var slot in slots) {
        Slot newSlot = Slot()
          ..ids = [slot['id']]
          ..isBooked = slot['scale_team'] != null
          ..isInvisible = slot['scale_team'] == 'invisible'
          ..beginAt = DateTime.parse(slot['begin_at'])
          ..endAt = DateTime.parse(slot['end_at'])
          ..bookedBy =
              slot['scale_team'] != null && slot['scale_team'] != 'invisible'
                  ? (slot['scale_team']['correcteds'] as List)
                      .map((corrected) => corrected['login'] as String)
                      .toList()
                  : []
          ..projectName =
              slot['scale_team'] != null && slot['scale_team'] != 'invisible'
                  ? await fetchProjectName(slot['scale_team']['scale_id'])
                  : null;
        allSlots.add(newSlot);
      }

      pageNumber++;
    }

    List<Slot> combinedSlots = combineAdjacentSlots(allSlots);
    convertSlotsToLocal(combinedSlots);

    return combinedSlots;
  }

  static Future<Color> fetchCoalitionColor(String userId) async {
    int? coalitionId;

    Color hexToColor(String hexString) {
      final buffer = StringBuffer();
      if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
      buffer.write(hexString.replaceFirst('#', ''));
      return Color(int.parse(buffer.toString(), radix: 16));
    }

    final response = await requestWithRetry(HttpMethod.get,
        createUri(endpoint: '/users/$userId/coalitions_users'), false);
    List<dynamic> coalitionUsers = json.decode(response.body);
    if (coalitionUsers.isNotEmpty) {
      coalitionId = coalitionUsers[0]['coalition_id'];
    }
    if (coalitionId != null) {
      Color? color = await CampusDataService.getCoalitionColor(coalitionId);
      if (color != null) {
        return color;
      }
      final coalitionResponse = await requestWithRetry(HttpMethod.get,
          createUri(endpoint: '/coalitions/$coalitionId'), false);
      Map<String, dynamic> coalitionData = json.decode(coalitionResponse.body);
      await CampusDataService.saveCoalitionColor(
          coalitionId, hexToColor(coalitionData['color']));
      return hexToColor(coalitionData['color']);
    }
    return AppTheme.intra;
  }

  static Future<DateTime?> fetchLastSeen(String userId) async {
    final response = await requestWithRetry(
        HttpMethod.get, createUri(endpoint: '/users/$userId/locations'), false);
    List<dynamic> locations = json.decode(response.body);
    if (locations.isNotEmpty) {
      if (locations[0]['end_at'] == null) {
        return null;
      }
      return DateTime.parse(locations[0]['end_at']);
    }
    return null;
  }

  static Future<Map<DateTime, List<Pair<Duration, Duration>>>>
      fetchMonthLogtime(String userId) async {
    DateTime now = DateTime.now();
    DateTime startMonth = DateTime(now.year, now.month - 3, 1);
    DateTime startDate = getFirstDayOfWeek(startMonth);
    final response = await requestWithRetry(
        HttpMethod.get,
        createUri(endpoint: '/users/$userId/locations_stats', queryParameters: {
          'begin_at': startDate.toIso8601String(),
        }),
        true);
    return convertLogData(response.body);
  }

  static Future<UserData> fetchProfile(
      {required bool isHomeView, String? userId}) async {
    String endpoint = isHomeView ? '/me' : '/users/$userId';
    final response = await requestWithRetry(
      HttpMethod.get,
      createUri(endpoint: endpoint),
      false,
    );
    Map<int, List<ProjectData>> projectsByCursusId = {};
    Map<String, dynamic> userDataAll = json.decode(response.body);

    Map<int, double> getLevels(List<dynamic> cursusUsers) {
      Map<int, double> levels = {};
      for (var cursus in cursusUsers) {
        levels[cursus['cursus_id']] = (cursus['level'] * 100).round() / 100;
      }
      return levels;
    }

    Map<String, double> getSkills(List<dynamic> cursusUsers) {
      Map<String, double> skills = {};
      final match21 = cursusUsers.firstWhere(
        (cursus) => cursus['cursus_id'] == 21,
        orElse: () => {},
      );

      final match = (match21.isNotEmpty)
          ? match21
          : cursusUsers.firstWhere(
              (cursus) => cursus['cursus_id'] == 9,
              orElse: () => {},
            );
      if (match.isEmpty) return skills;
      for (var skill in match['skills']) {
        skills[skill['name']] = (skill['level'] * 10).round() / 10;
      }
      return skills;
    }

    List<Campus> getCampuses(
        List<dynamic> campusList, List<dynamic> campusUsers) {
      List<Campus> campuses = [];
      for (var campus in campusList) {
        DateTime? enrollmentDate;
        for (var campusUser in campusUsers) {
          if (campusUser['campus_id'] == campus['id']) {
            enrollmentDate = DateTime.parse(campusUser['created_at']);
            break;
          }
        }
        Campus camp = Campus()
          ..id = campus['id']
          ..name = campus['name']
          ..country = campus['country']
          ..city = campus['city']
          ..usersCount = campus['users_count']
          ..isActive = campus['active']
          ..enrollmentDate = enrollmentDate
          ..website = normalizeUrl(campus['website'] ?? '');
        campuses.add(camp);
      }
      campuses.sort((a, b) {
        if (a.enrollmentDate != null && b.enrollmentDate != null) {
          return b.enrollmentDate!.compareTo(a.enrollmentDate!);
        } else if (a.enrollmentDate != null) {
          return -1;
        } else if (b.enrollmentDate != null) {
          return 1;
        } else {
          return 0;
        }
      });
      return campuses;
    }

    int getCurrentCampusId(List<dynamic> campusUsers) {
      for (var campusUser in campusUsers) {
        if (campusUser['is_primary'] == true) {
          return campusUser['campus_id'];
        }
      }
      return campusUsers.last['campus_id'];
    }

    UserData userData = UserData();
    userData.id = userDataAll['id'];
    userData.login = userDataAll['login'];
    userData.firstName = userDataAll['first_name'];
    userData.lastName = userDataAll['last_name'];
    userData.imageUrlBig = userDataAll['image']['link'];
    userData.imageUrlSmall = userDataAll['image']['versions']['small'];
    userData.location = userDataAll['location'];
    userData.wallet = userDataAll['wallet'];
    userData.evalPoints = userDataAll['correction_point'];
    userData.poolMonth = userDataAll['pool_month'];
    userData.poolYear = userDataAll['pool_year'];
    userData.isActive = userDataAll['active?'];
    userData.isStaff = userDataAll['staff?'];
    userData.cursusLevels =
        getLevels(userDataAll['cursus_users'] as List<dynamic>);
    for (var cursus in userDataAll['cursus_users']) {
      userData.cursusNames[cursus['cursus_id']] = cursus['cursus']['name'];
    }
    userData.currentCampusId = getCurrentCampusId(userDataAll['campus_users']);
    userData.campuses =
        getCampuses(userDataAll['campus'], userDataAll['campus_users']);
    for (var project in userDataAll['projects_users']) {
      List<int> cursusIds = List<int>.from(project['cursus_ids']);
      ProjectData projectData = ProjectData()
        ..projectId = project['project']['id']
        ..name = project['project']['name']
        ..status = project['status']
        ..validated = project['validated?']
        ..timeStamp = (project['validated?'] != true)
            ? DateTime.parse(project['created_at'])
            : DateTime.parse(project['marked_at'])
        ..finalMark = project['final_mark'];
      for (int cursusId in cursusIds) {
        if (!projectsByCursusId.containsKey(cursusId)) {
          projectsByCursusId[cursusId] = [];
        }
        projectsByCursusId[cursusId]?.add(projectData);
      }
    }
    userData.projectsByCursusId = projectsByCursusId;
    userData.skills = getSkills(userDataAll['cursus_users'] as List<dynamic>);
    return userData;
  }

  static Future<List<TeamData>> fetchProjectTeams(
      int projectId, int userId) async {
    final response = await requestWithRetry(
        HttpMethod.get,
        createUri(
            endpoint: '/projects/$projectId/projects_users',
            queryParameters: {
              'filter[user_id]': '$userId',
            }),
        false);
    List<dynamic> resp = json.decode(response.body);
    List<TeamData> teams = [];
    for (var team in resp[0]['teams']) {
      TeamData teamData = TeamData()
        ..id = team['id']
        ..name = team['name']
        ..finalMark = team['final_mark']
        ..isFailed = team['validated?'] == false;
      List<dynamic> members = team['users'];
      for (var member in members) {
        teamData.members[member['login']] = member['leader'];
      }
      teams.add(teamData);
    }
    return teams.reversed.toList();
  }

  static Future<List<FeedbackData>> fetchFeedbacks(
      int projectId, int teamId) async {
    final response = await requestWithRetry(
        HttpMethod.get,
        createUri(
            endpoint: '/projects/$projectId/scale_teams',
            queryParameters: {
              'filter[team_id]': '$teamId',
            }),
        false);
    List<dynamic> feedbacks = json.decode(response.body);
    List<FeedbackData> feedbackData = [];
    for (var feedback in feedbacks) {
      FeedbackData feedbackItem = FeedbackData()
        ..mark = feedback['final_mark'] ?? 0
        ..corrector = feedback['corrector']['login'] ?? ''
        ..comment = feedback['comment'] ?? ''
        ..feedback = feedback['feedback'] ?? ''
        ..isFailed = feedback['team']['validated?'] == false
        ..time = DateTime.parse(feedback['created_at']);
      feedbackData.add(feedbackItem);
    }
    return feedbackData;
  }

  static Future<Map<int, int>> fetchSubscribedEventIds(int userId) async {
    int pageNumber = 1;
    int totalPages = 1;
    Map<int, int> eventIds = {};
    DateTime now = DateTime.now();
    DateTime oneYearAgo = DateTime(now.year - 1, now.month, now.day);
    while (pageNumber <= totalPages) {
      final response = await requestWithRetry(
          HttpMethod.get,
          createUri(endpoint: '/users/$userId/events_users', queryParameters: {
            'page[number]': pageNumber.toString(),
            'page[size]': '100',
            'range[created_at]':
                '${oneYearAgo.toIso8601String()},${now.toIso8601String()}',
          }),
          false);
      List<dynamic> events = json.decode(response.body);
      for (var event in events) {
        eventIds[event['event_id']] = event['id'];
      }
      if (pageNumber == 1) {
        totalPages = getPagesNumberFromHeader(response);
      }
      pageNumber++;
    }
    return eventIds;
  }

  static Future<void> subscribeToEvent(int eventId, int myId) async {
    await requestWithRetry(
        HttpMethod.post,
        createUri(endpoint: '/events_users', queryParameters: {
          'events_user[event_id]': eventId.toString(),
          'events_user[user_id]': myId.toString(),
        }),
        false);
  }

  static Future<void> unsubscribeFromEvent(int eventId) async {
    await requestWithRetry(HttpMethod.delete,
        createUri(endpoint: '/events_users/$eventId'), false);
  }
}
