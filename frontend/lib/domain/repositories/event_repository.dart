import '../entities/event.dart';

abstract class EventRepository {
  Future<List<Event>> fetchEvents();
  Future<Event> updateEvent(Event event);
}
