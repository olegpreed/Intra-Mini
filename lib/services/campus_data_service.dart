import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/services/user_data_service.dart';
import 'package:forty_two_planet/utils/http_utils.dart';
import 'package:forty_two_planet/utils/string_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Event {
  int? id;
  String? name;
  bool isExam = false;
  String? description;
  String? location;
  String? kind;
  int? maxPeople;
  int? subscrCount;
  DateTime? beginAt;
  DateTime? endAt;
}

class CampusStore extends ChangeNotifier {
  List<Event> _events = [];

  List<Event> get events => _events;

  void setEvents(List<Event> fetchedEvents) {
    _events = List.from(fetchedEvents);
    notifyListeners();
  }
}

class CampusDataService {
  static Future<void> saveCoalitionColor(int coalitionId, Color color) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('coalition$coalitionId', color.value);
  }

  static Future<Color?> getCoalitionColor(int coalitionId) async {
    final prefs = await SharedPreferences.getInstance();
    final colorValue = prefs.getInt('coalition$coalitionId');
    return colorValue != null ? Color(colorValue) : null;
  }

  static Future<List<Event>> fetchEvents(
      int campusId, bool includeExams) async {
    List<Event> allEvents = [];
    int pageNumber = 1;
    int totalPages = 1;
    while (pageNumber <= totalPages) {
      final response = await requestWithRetry(
          HttpMethod.get,
          createUri(endpoint: '/campus/$campusId/events', queryParameters: {
            'page[number]': pageNumber.toString(),
            'page[size]': '100',
            'sort': 'begin_at',
            'filter[future]': 'true'
          }),
          false);
      if (pageNumber == 1) {
        totalPages = getPagesNumberFromHeader(response);
      }

      List<dynamic> responseData = json.decode(response.body);

      List<Event> eventsData = responseData.map<Event>((event) {
        return Event()
          ..id = event['id']
          ..name = event['name']
          ..description = event['description']
          ..location = event['location']
          ..kind = formatKind(event['kind'])
          ..maxPeople = event['max_people']
          ..subscrCount = event['nbr_subscribers']
          ..beginAt = (DateTime.parse(event['begin_at']).toLocal())
          ..endAt = (DateTime.parse(event['end_at']).toLocal());
      }).toList();

      allEvents.addAll(eventsData);
      pageNumber++;
    }

    if (includeExams) {
      final exams = await fetchExams(campusId);
      allEvents.addAll(exams);
      allEvents.sort((a, b) => a.beginAt!.compareTo(b.beginAt!));
    }

    return allEvents;
  }

  static Future<List<Event>> fetchExams(int campusId) async {
    List<Event> allExams = [];
    Set<int> seenIds = {};
    int pageNumber = 1;
    int totalPages = 1;
    while (pageNumber <= totalPages) {
      final response = await requestWithRetry(
          HttpMethod.get,
          createUri(endpoint: '/cursus/21/exams', queryParameters: {
            'page[number]': pageNumber.toString(),
            'sort': 'begin_at',
            'filter[future]': 'true',
            'filter[campus_id]': campusId.toString(),
          }),
          true);

      if (pageNumber == 1) {
        totalPages = getPagesNumberFromHeader(response);
      }

      List<dynamic> responseData = json.decode(response.body);

      List<Event> eventsData = responseData.map<Event>((exam) {
        return Event()
          ..id = exam['id']
          ..name = exam['name']
          ..location = exam['location']
          ..maxPeople = exam['max_people']
          ..subscrCount = exam['nbr_subscribers']
          ..isExam = true
          ..description = exam['projects'].map<String>((project) {
            return project['name'] as String;
          }).join(', ')
          ..beginAt = DateTime.parse(exam['begin_at']).toLocal()
          ..endAt = DateTime.parse(exam['end_at']).toLocal();
      }).where((event) {
        if (seenIds.contains(event.id)) {
          return false;
        } else {
          seenIds.add(event.id!);
          return true;
        }
      }).toList();

      allExams.addAll(eventsData);
      pageNumber++;
    }

    return allExams;
  }

  static Future<Map<UserData, SearchProjectData>> fetchProjectCadets(
      int campusId, int projectId, String projectStatus) async {
    int pageSize = 100;
    DateTime beginAt =
        DateTime.now().subtract(const Duration(days: 180)).toUtc();
    DateTime endAt = DateTime.now().toUtc();
    int pageNumber = 1;
    int totalPages = 1;
    Map<UserData, SearchProjectData> cadetProjectMap = {};
    while (pageNumber <= totalPages) {
      final response = await requestWithRetry(
          HttpMethod.get,
          createUri(
              endpoint: '/projects/$projectId/projects_users',
              queryParameters: {
                'filter[campus]': campusId.toString(),
                'page[size]': pageSize.toString(),
                'page[number]': pageNumber.toString(),
                'filter[status]': projectStatus,
                'filter[marked]':
                    projectStatus == 'finished' ? 'true' : 'false',
                'range[${projectStatus == 'finished' ? 'marked_at' : 'created_at'}]':
                    '$beginAt,$endAt',
              }),
          false);

      if (pageNumber == 1) {
        totalPages = getPagesNumberFromHeader(response);
      }

      List<dynamic> responseData = json.decode(response.body);

      for (var cadet in responseData) {
        if (cadet['user']['staff?'] != true &&
            cadet['user']['active?'] == true) {
          UserData userData = UserData()
            ..id = cadet['user']['id']
            ..login = cadet['user']['login']
            ..firstName = cadet['user']['first_name']
            ..lastName = cadet['user']['last_name']
            ..imageUrlSmall = cadet['user']['image']['versions']['small']
            ..imageUrlBig = cadet['user']['image']['link']
            ..wallet = cadet['user']['wallet']
            ..location = cadet['user']['location']
            ..evalPoints = cadet['user']['correction_point']
            ..poolMonth = cadet['user']['pool_month']
            ..poolYear = cadet['user']['pool_year'];
          DateTime? projectStamp;
          if (projectStatus == 'finished') {
            projectStamp = DateTime.parse(cadet['marked_at']);
          } else if (projectStatus == 'in_progress') {
            projectStamp = DateTime.parse(cadet['created_at']);
          }

          SearchProjectData projectData = SearchProjectData()
            ..teamId = cadet['current_team_id']
            ..teamName = cadet['teams'].isNotEmpty &&
                    cadet['teams'][0]['users'].length > 1
                ? cadet['teams'][0]['name']
                : null
            ..timeStamp = projectStamp
            ..finalMark =
                projectStatus == 'finished' ? cadet['final_mark'] : null
            ..isFailed =
                projectStatus == 'finished' && cadet['validated?'] == false;

          cadetProjectMap[userData] = projectData;
        }
      }
      pageNumber++;
    }
    return cadetProjectMap;
  }

  static Future<List<UserData>> fetchCampusCadets(int campusId, int pageNumber,
      List<int> totalPages, RangeValues minMaxLevels) async {
    int cursusId = 21;
    bool hasCoalition = true;
    bool isActive = true;
    int pageSize = 100;
    String sort = 'level';
    final response = await requestWithRetry(
        HttpMethod.get,
        createUri(endpoint: '/cursus/$cursusId/cursus_users', queryParameters: {
          'range[level]':
              '${minMaxLevels.start},${minMaxLevels.end + 1 - 1e-10}',
          'filter[campus_id]': campusId.toString(),
          'filter[has_coalition]': hasCoalition.toString(),
          'filter[active]': isActive.toString(),
          'sort': sort,
          'page[size]': pageSize.toString(),
          'page[number]': pageNumber.toString(),
        }),
        false);

    if (pageNumber == 1) {
      totalPages[0] = getPagesNumberFromHeader(response);
    }
    List<dynamic> responseData = json.decode(response.body);
    List<UserData> cadets = responseData
        .where((cadet) => cadet['user']['staff?'] != true)
        .map<UserData>((cadet) {
      return UserData()
        ..id = cadet['user']['id']
        ..login = cadet['user']['login']
        ..firstName = cadet['user']['first_name']
        ..lastName = cadet['user']['last_name']
        ..imageUrlSmall = cadet['user']['image']['versions']['small']
        ..imageUrlBig = cadet['user']['image']['link']
        ..location = cadet['user']['location']
        ..wallet = cadet['user']['wallet']
        ..evalPoints = cadet['user']['correction_point']
        ..level = (cadet['level'] * 100).round() / 100
        ..poolYear = cadet['user']['pool_year']
        ..poolMonth = cadet['user']['pool_month']
        ..isActive = cadet['user']['active?'];
    }).toList();

    return cadets;
  }
}
