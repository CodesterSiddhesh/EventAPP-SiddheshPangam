import '../entities/event.dart';
import '../repositories/event_repository.dart';

class UpdateEvent {
  const UpdateEvent(this.repository);

  final EventRepository repository;

  Future<Event> call(Event event) async {
    return await repository.updateEvent(event);
  }
}