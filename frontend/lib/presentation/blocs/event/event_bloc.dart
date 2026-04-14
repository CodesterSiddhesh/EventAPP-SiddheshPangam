import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/fetch_events.dart';
import '../../../domain/usecases/update_event.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  EventBloc({required this.fetchEvents, required this.updateEvent}) : super(const EventInitial()) {
    on<FetchEventsRequested>(_onFetchEventsRequested);
    on<UpdateEventRequested>(_onUpdateEventRequested);
  }

  final FetchEvents fetchEvents;
  final UpdateEvent updateEvent;

  Future<void> _onFetchEventsRequested(
    FetchEventsRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventLoadInProgress());

    try {
      final events = await fetchEvents();
      emit(EventLoadSuccess(events));
    } catch (error) {
      emit(EventLoadFailure(error.toString()));
    }
  }

  Future<void> _onUpdateEventRequested(
    UpdateEventRequested event,
    Emitter<EventState> emit,
  ) async {
    emit(const EventUpdateInProgress());

    try {
      final updatedEvent = await updateEvent(event.event);
      emit(EventUpdateSuccess(updatedEvent));
    } catch (error) {
      emit(EventUpdateFailure(error.toString()));
    }
  }
}
