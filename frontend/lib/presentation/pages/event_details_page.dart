import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/event.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_state.dart';
import '../blocs/event/event_bloc.dart';
import 'edit_event_page.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key, required this.event});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            if (event.thumbnailUrl != null)
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(event.thumbnailUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // Title
            Text(
              event.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(height: 8),

            // Category and Status
            Row(
              children: [
                if (event.category != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.category!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                if (event.status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: event.status == 'published'
                          ? Colors.green.shade100
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      event.status!.toUpperCase(),
                      style: TextStyle(
                        color: event.status == 'published'
                            ? Colors.green.shade800
                            : Colors.grey.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              event.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const SizedBox(height: 24),

            // Event Details
            _buildDetailSection(
              context,
              'Event Details',
              [
                _buildDetailRow('ID', event.id.toString()),
                if (event.slug != null)
                  _buildDetailRow('Slug', event.slug!),
                if (event.eventType != null)
                  _buildDetailRow('Type', event.eventType!.toUpperCase()),
                if (event.startTime != null)
                  _buildDetailRow('Start Time', _formatDateTime(event.startTime!)),
                if (event.endTime != null)
                  _buildDetailRow('End Time', _formatDateTime(event.endTime!)),
                if (event.timezone != null)
                  _buildDetailRow('Timezone', event.timezone!),
                if (event.capacity != null)
                  _buildDetailRow('Capacity', event.capacity.toString()),
                if (event.ticketPrice != null)
                  _buildDetailRow('Ticket Price', '\$${event.ticketPrice}'),
                if (event.status != null)
                  _buildDetailRow('Status', event.status!.toUpperCase()),
                if (event.isPublic != null)
                  _buildDetailRow('Public', event.isPublic! ? 'Yes' : 'No'),
                if (event.isArchived != null)
                  _buildDetailRow('Archived', event.isArchived! ? 'Yes' : 'No'),
                if (event.publishedAt != null)
                  _buildDetailRow('Published At', _formatDateTime(event.publishedAt!)),
                if (event.archivedAt != null)
                  _buildDetailRow('Archived At', _formatDateTime(event.archivedAt!)),
              ],
            ),

            const SizedBox(height: 24),

            // Metadata
            if (event.metadata != null && event.metadata!.isNotEmpty)
              _buildDetailSection(
                context,
                'Metadata',
                event.metadata!.entries.map((entry) {
                  return _buildDetailRow(entry.key, entry.value.toString());
                }).toList(),
              ),

            const SizedBox(height: 32),

            // Action Buttons
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final isAdmin = authState is AuthAuthenticated &&
                    authState.user.roles?.contains('admin') == true;

                if (isAdmin) {
                  return ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditEventPage(
                            event: event,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Event'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  );
                }

                // No buttons for non-admin users
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, List<Widget> children) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return DateFormat('MMM dd, yyyy • hh:mm a').format(dateTime);
    } catch (e) {
      return dateTimeString;
    }
  }
}