<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreEventRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            // Basic Information
            'title' => 'required|string|max:255',
            'slug' => 'required|string|max:255|unique:events,slug',
            'description' => 'nullable|string|max:5000',
            
            // Event Scheduling
            'start_time' => 'required|date_format:Y-m-d H:i:s',
            'end_time' => 'required|date_format:Y-m-d H:i:s|after:start_time',
            'timezone' => 'nullable|string|max:50',
            
            // Location & Event Type
            'event_type' => 'required|in:in-person,online,hybrid',
            'location' => 'nullable|string|max:255',
            'city' => 'nullable|string|max:100',
            
            // Online Event Details
            'meeting_url' => 'nullable|url',
            
            // Media & Display
            'thumbnail_url' => 'nullable|url',
            'category' => 'nullable|string|max:100',
            
            // Capacity & Registration
            'capacity' => 'nullable|integer|min:1',
            'ticket_price' => 'nullable|numeric|min:0',
            
            // Visibility & Status
            'status' => 'required|in:draft,published,cancelled',
            'is_public' => 'nullable|boolean',
            'is_archived' => 'nullable|boolean',
            'published_at' => 'nullable|date_format:Y-m-d H:i:s',
            'archived_at' => 'nullable|date_format:Y-m-d H:i:s',
            
            // Metadata
            'metadata' => 'nullable|json',
        ];
    }

    /**
     * Get custom validation messages.
     */
    public function messages(): array
    {
        return [
            'title.required' => 'Event title is required.',
            'slug.unique' => 'This slug is already taken.',
            'start_time.required' => 'Event start time is required.',
            'end_time.after' => 'Event end time must be after start time.',
            'event_type.required' => 'Please select an event type.',
            'status.required' => 'Please select an event status.',
            'meeting_url.url' => 'Please provide a valid meeting URL.',
            'thumbnail_url.url' => 'Please provide a valid thumbnail URL.',
            'capacity.min' => 'Capacity must be at least 1.',
            'ticket_price.min' => 'Ticket price cannot be negative.',
        ];
    }
}
