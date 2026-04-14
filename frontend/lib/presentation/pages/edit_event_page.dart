import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/event.dart';
import '../blocs/event/event_bloc.dart';
import '../blocs/event/event_event.dart';
import '../blocs/event/event_state.dart';

class EditEventPage extends StatefulWidget {
  const EditEventPage({super.key, required this.event});

  final Event event;

  @override
  State<EditEventPage> createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  late final TextEditingController _cityController;
  late final TextEditingController _meetingUrlController;
  late final TextEditingController _categoryController;
  late final TextEditingController _capacityController;
  late final TextEditingController _ticketPriceController;
  late final TextEditingController _startTimeController;
  late final TextEditingController _endTimeController;
  late final TextEditingController _timezoneController;

  String? _selectedEventType;
  String? _selectedStatus;
  bool _isPublic = false;
  bool _isArchived = false;

  final List<String> _eventTypes = ['online', 'in-person', 'hybrid'];
  final List<String> _statuses = ['draft', 'published', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _descriptionController = TextEditingController(text: widget.event.description);
    _locationController = TextEditingController(text: widget.event.location);
    _cityController = TextEditingController(text: widget.event.city);
    _meetingUrlController = TextEditingController(text: widget.event.meetingUrl);
    _categoryController = TextEditingController(text: widget.event.category);
    _capacityController = TextEditingController(text: widget.event.capacity?.toString());
    _ticketPriceController = TextEditingController(text: widget.event.ticketPrice);
    _startTimeController = TextEditingController(text: widget.event.startTime);
    _endTimeController = TextEditingController(text: widget.event.endTime);
    _timezoneController = TextEditingController(text: widget.event.timezone);

    _selectedEventType = widget.event.eventType;
    _selectedStatus = widget.event.status;
    _isPublic = widget.event.isPublic ?? false;
    _isArchived = widget.event.isArchived ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _meetingUrlController.dispose();
    _categoryController.dispose();
    _capacityController.dispose();
    _ticketPriceController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Event'),
        actions: [
          TextButton(
            onPressed: _saveEvent,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event updated successfully!')),
            );
            Navigator.of(context).pop(); // Go back to event details
          } else if (state is EventUpdateFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update event: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<EventBloc, EventState>(
          builder: (context, state) {
            final isLoading = state is EventUpdateInProgress;

            return Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information
                    _buildSectionTitle('Basic Information'),
                    _buildTextField(
                      controller: _titleController,
                      label: 'Title',
                      validator: (value) => value?.isEmpty == true ? 'Title is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _descriptionController,
                      label: 'Description',
                      maxLines: 4,
                      validator: (value) => value?.isEmpty == true ? 'Description is required' : null,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _categoryController,
                      label: 'Category',
                    ),

                    const SizedBox(height: 24),

                    // Event Type and Status
                    _buildSectionTitle('Event Settings'),
                    _buildDropdownField(
                      label: 'Event Type',
                      value: _selectedEventType,
                      items: _eventTypes,
                      onChanged: (value) => setState(() => _selectedEventType = value),
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Status',
                      value: _selectedStatus,
                      items: _statuses,
                      onChanged: (value) => setState(() => _selectedStatus = value),
                    ),
                    const SizedBox(height: 16),
                    _buildSwitchField(
                      label: 'Public Event',
                      value: _isPublic,
                      onChanged: (value) => setState(() => _isPublic = value),
                    ),
                    const SizedBox(height: 16),
                    _buildSwitchField(
                      label: 'Archived',
                      value: _isArchived,
                      onChanged: (value) => setState(() => _isArchived = value),
                    ),

                    const SizedBox(height: 24),

                    // Date and Time
                    _buildSectionTitle('Date & Time'),
                    _buildTextField(
                      controller: _startTimeController,
                      label: 'Start Time (ISO format)',
                      hint: '2026-05-11T10:23:24.000000Z',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _endTimeController,
                      label: 'End Time (ISO format)',
                      hint: '2026-06-01T22:49:44.000000Z',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _timezoneController,
                      label: 'Timezone',
                      hint: 'America/New_York',
                    ),

                    const SizedBox(height: 24),

                    // Location
                    _buildSectionTitle('Location'),
                    _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      enabled: _selectedEventType == 'in-person' || _selectedEventType == 'hybrid',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _cityController,
                      label: 'City',
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _meetingUrlController,
                      label: 'Meeting URL',
                      enabled: _selectedEventType == 'online' || _selectedEventType == 'hybrid',
                    ),

                    const SizedBox(height: 24),

                    // Capacity and Pricing
                    _buildSectionTitle('Capacity & Pricing'),
                    _buildTextField(
                      controller: _capacityController,
                      label: 'Capacity',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _ticketPriceController,
                      label: 'Ticket Price',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),

                    const SizedBox(height: 32),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _saveEvent,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Save Changes'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: const OutlineInputBorder(),
        enabled: enabled,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      enabled: enabled,
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item.toUpperCase()),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? '$label is required' : null,
    );
  }

  Widget _buildSwitchField({
    required String label,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _saveEvent() {
    if (!_formKey.currentState!.validate()) return;

    final updatedEvent = Event(
      id: widget.event.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      slug: widget.event.slug, // Keep existing slug
      startTime: _startTimeController.text.trim().isEmpty ? null : _startTimeController.text.trim(),
      endTime: _endTimeController.text.trim().isEmpty ? null : _endTimeController.text.trim(),
      timezone: _timezoneController.text.trim().isEmpty ? null : _timezoneController.text.trim(),
      eventType: _selectedEventType,
      location: _locationController.text.trim().isEmpty ? null : _locationController.text.trim(),
      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
      meetingUrl: _meetingUrlController.text.trim().isEmpty ? null : _meetingUrlController.text.trim(),
      thumbnailUrl: widget.event.thumbnailUrl, // Keep existing thumbnail
      category: _categoryController.text.trim().isEmpty ? null : _categoryController.text.trim(),
      capacity: _capacityController.text.trim().isEmpty ? null : int.tryParse(_capacityController.text.trim()),
      ticketPrice: _ticketPriceController.text.trim().isEmpty ? null : _ticketPriceController.text.trim(),
      status: _selectedStatus,
      isPublic: _isPublic,
      isArchived: _isArchived,
      publishedAt: widget.event.publishedAt, // Keep existing timestamps
      archivedAt: widget.event.archivedAt,
      metadata: widget.event.metadata, // Keep existing metadata
    );

    context.read<EventBloc>().add(UpdateEventRequested(updatedEvent));
  }
}