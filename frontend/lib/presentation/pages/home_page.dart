import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/event/event_bloc.dart';
import '../blocs/event/event_event.dart';
import '../blocs/event/event_state.dart';
import '../widgets/event_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event App'),
        actions: [
          IconButton(
            onPressed: () => context.read<AuthBloc>().add(const LogoutRequested()),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventLoadInProgress) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EventLoadSuccess) {
            return EventList(events: state.events);
          }
          if (state is EventLoadFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<EventBloc>().add(const FetchEventsRequested()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(
            child: ElevatedButton(
              onPressed: () => context.read<EventBloc>().add(const FetchEventsRequested()),
              child: const Text('Load events'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<EventBloc>().add(const FetchEventsRequested()),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
