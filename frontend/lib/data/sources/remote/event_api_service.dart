import '../../../core/config/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../models/event_model.dart';

class EventApiService {
  EventApiService({required this.apiClient});

  final ApiClient apiClient;

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await apiClient.get(ApiConstants.eventsPath);
      final data = response.data;

      // Handle different response formats
      List<dynamic> rawList;
      if (data is List) {
        rawList = data;
      } else if (data is Map<String, dynamic>) {
        // Check for wrapped responses
        if (data.containsKey('data') && data['data'] is List) {
          rawList = data['data'] as List;
        } else if (data.containsKey('events') && data['events'] is List) {
          rawList = data['events'] as List;
        } else if (data.containsKey('results') && data['results'] is List) {
          rawList = data['results'] as List;
        } else {
          // If it's a map but doesn't contain expected list fields, treat it as an error
          throw Exception('Unexpected response format: ${data.keys.join(', ')}');
        }
      } else {
        throw Exception('Unexpected response type: ${data.runtimeType}');
      }

      return rawList.map((item) {
        try {
          if (item is Map<String, dynamic>) {
            return EventModel.fromJson(item);
          } else {
            throw Exception('Unexpected item format: ${item.runtimeType}');
          }
        } catch (e) {
          print('Error parsing event item: $item');
          print('Error: $e');
          rethrow;
        }
      }).toList();
    } catch (e) {
      print('Error in fetchEvents: $e');
      rethrow;
    }
  }

  Future<EventModel> updateEvent(EventModel event) async {
    try {
      final response = await apiClient.put(
        '${ApiConstants.eventsPath}/${event.id}',
        data: {
          'title': event.title,
          'description': event.description,
          'start_time': event.startTime,
          'end_time': event.endTime,
          'timezone': event.timezone,
          'event_type': event.eventType,
          'location': event.location,
          'city': event.city,
          'meeting_url': event.meetingUrl,
          'category': event.category,
          'capacity': event.capacity,
          'ticket_price': event.ticketPrice,
          'status': event.status,
          'is_public': event.isPublic,
          'is_archived': event.isArchived,
        },
      );

      return EventModel.fromJson(response.data);
    } catch (e) {
      print('Error in updateEvent: $e');
      rethrow;
    }
  }
}
