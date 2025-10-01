import 'package:forty_two_planet/services/campus_data_service.dart';
import 'package:forty_two_planet/services/user_data_service.dart';

List<Event> fakeEvents = [
  Event(
    id: 1,
    name: 'Hackathon 2024',
    description: 'Join us for a 48-hour coding marathon!',
    subscrCount: 2,
    beginAt: DateTime(2025, 10, 1),
    endAt: DateTime(2025, 10, 2),
    location: 'Campus Auditorium',
  ),
  Event(
    id: 2,
    name: 'Tech Talk: AI Innovations',
    description: 'Explore the latest trends in AI technology.',
    subscrCount: 5,
    beginAt: DateTime(2025, 10, 2),
    endAt: DateTime(2025, 10, 5),
    location: 'Room 101',
  ),
];

List<Slot> fakeSlots = [
  Slot(
      ids: [1, 2, 3],
      isBooked: true,
      isInvisible: false,
      beginAt: DateTime(2025, 10, 1, 22, 0),
      endAt: DateTime(2025, 10, 1, 23, 0),
      bookedBy: ['preed'],
      projectName: 'Libft'),
  Slot(
      ids: [4, 5, 6],
      isBooked: false,
      isInvisible: false,
      beginAt: DateTime(2025, 10, 1, 24, 0),
      endAt: DateTime(2025, 10, 1, 24, 30),
      bookedBy: [],
      projectName: ''),
];
