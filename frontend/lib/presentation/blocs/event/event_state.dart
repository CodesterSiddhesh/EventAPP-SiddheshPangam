import 'package:equatable/equatable.dart';

import '../../../domain/entities/event.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {
  const EventInitial();
}

class EventLoadInProgress extends EventState {
  const EventLoadInProgress();
}

class EventLoadSuccess extends EventState {
  const EventLoadSuccess(this.events);

  final List<Event> events;

  @override
  List<Object?> get props => [events];
}

class EventLoadFailure extends EventState {
  const EventLoadFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class EventUpdateInProgress extends EventState {
  const EventUpdateInProgress();
}

class EventUpdateSuccess extends EventState {
  const EventUpdateSuccess(this.event);

  final Event event;

  @override
  List<Object?> get props => [event];
}

class EventUpdateFailure extends EventState {
  const EventUpdateFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
