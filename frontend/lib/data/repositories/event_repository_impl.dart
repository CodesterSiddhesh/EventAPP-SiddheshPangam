import '../../domain/entities/event.dart';
import '../../domain/repositories/event_repository.dart';
import '../models/event_model.dart';
import '../sources/remote/event_api_service.dart';

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl({required this.eventApiService});

  final EventApiService eventApiService;

  @override
  Future<List<Event>> fetchEvents() {
    return eventApiService.fetchEvents();
  }

  @override
  Future<Event> updateEvent(Event event) async {
    // Convert Event to EventModel for API call
    final eventModel = EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      slug: event.slug,
      startTime: event.startTime,
      endTime: event.endTime,
      timezone: event.timezone,
      eventType: event.eventType,
      location: event.location,
      city: event.city,
      meetingUrl: event.meetingUrl,
      thumbnailUrl: event.thumbnailUrl,
      category: event.category,
      capacity: event.capacity,
      ticketPrice: event.ticketPrice,
      status: event.status,
      isPublic: event.isPublic,
      isArchived: event.isArchived,
      publishedAt: event.publishedAt,
      archivedAt: event.archivedAt,
      metadata: event.metadata,
    );

    return await eventApiService.updateEvent(eventModel);
  }
}
