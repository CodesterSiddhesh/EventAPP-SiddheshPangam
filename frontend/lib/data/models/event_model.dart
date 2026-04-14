import '../../domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.description,
    super.slug,
    super.startTime,
    super.endTime,
    super.timezone,
    super.eventType,
    super.location,
    super.city,
    super.meetingUrl,
    super.thumbnailUrl,
    super.category,
    super.capacity,
    super.ticketPrice,
    super.status,
    super.isPublic,
    super.isArchived,
    super.publishedAt,
    super.archivedAt,
    super.metadata,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      slug: json['slug']?.toString(),
      startTime: json['start_time']?.toString(),
      endTime: json['end_time']?.toString(),
      timezone: json['timezone']?.toString(),
      eventType: json['event_type']?.toString(),
      location: json['location']?.toString(),
      city: json['city']?.toString(),
      meetingUrl: json['meeting_url']?.toString(),
      thumbnailUrl: json['thumbnail_url']?.toString(),
      category: json['category']?.toString(),
      capacity: json['capacity'] is int ? json['capacity'] : int.tryParse(json['capacity']?.toString() ?? ''),
      ticketPrice: json['ticket_price']?.toString(),
      status: json['status']?.toString(),
      isPublic: json['is_public'] is bool ? json['is_public'] : null,
      isArchived: json['is_archived'] is bool ? json['is_archived'] : null,
      publishedAt: json['published_at']?.toString(),
      archivedAt: json['archived_at']?.toString(),
      metadata: json['metadata'] is Map<String, dynamic> ? json['metadata'] : null,
    );
  }
}
