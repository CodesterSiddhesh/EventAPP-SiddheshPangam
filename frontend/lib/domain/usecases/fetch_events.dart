import '../entities/event.dart';
import '../repositories/event_repository.dart';

class FetchEvents {
  FetchEvents(this.repository);

  final EventRepository repository;

  Future<List<Event>> call() {
    return repository.fetchEvents();
  }
}
