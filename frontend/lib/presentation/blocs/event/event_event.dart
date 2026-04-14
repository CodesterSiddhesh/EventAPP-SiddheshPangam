import 'package:equatable/equatable.dart';

import '../../../domain/entities/event.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();

  @override
  List<Object?> get props => [];
}

class FetchEventsRequested extends EventEvent {
  const FetchEventsRequested();
}

class UpdateEventRequested extends EventEvent {
  const UpdateEventRequested(this.event);

  final Event event;

  @override
  List<Object?> get props => [event];
}
