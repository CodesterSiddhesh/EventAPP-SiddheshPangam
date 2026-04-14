import 'package:equatable/equatable.dart';

class Event extends Equatable {
  const Event({
    required this.id,
    required this.title,
    required this.description,
    this.slug,
    this.startTime,
    this.endTime,
    this.timezone,
    this.eventType,
    this.location,
    this.city,
    this.meetingUrl,
    this.thumbnailUrl,
    this.category,
    this.capacity,
    this.ticketPrice,
    this.status,
    this.isPublic,
    this.isArchived,
    this.publishedAt,
    this.archivedAt,
    this.metadata,
  });

  final int id;
  final String title;
  final String description;
  final String? slug;
  final String? startTime;
  final String? endTime;
  final String? timezone;
  final String? eventType;
  final String? location;
  final String? city;
  final String? meetingUrl;
  final String? thumbnailUrl;
  final String? category;
  final int? capacity;
  final String? ticketPrice;
  final String? status;
  final bool? isPublic;
  final bool? isArchived;
  final String? publishedAt;
  final String? archivedAt;
  final Map<String, dynamic>? metadata;

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        slug,
        startTime,
        endTime,
        timezone,
        eventType,
        location,
        city,
        meetingUrl,
        thumbnailUrl,
        category,
        capacity,
        ticketPrice,
        status,
        isPublic,
        isArchived,
        publishedAt,
        archivedAt,
        metadata,
      ];
}
