<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateEventRequest extends FormRequest
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
            'title' => 'sometimes|required|string|max:255',
            'slug' => 'sometimes|required|string|max:255|unique:events,slug,' . $this->route('event')->id,
            'description' => 'nullable|string|max:5000',
            
            // Event Scheduling
            'start_time' => 'sometimes|required|date_format:Y-m-d H:i:s',
            'end_time' => 'sometimes|required|date_format:Y-m-d H:i:s|after:start_time',
            'timezone' => 'nullable|string|max:50',
            
            // Location & Event Type
            'event_type' => 'sometimes|required|in:in-person,online,hybrid',
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
            'status' => 'sometimes|required|in:draft,published,cancelled',
            'is_public' => 'nullable|boolean',
            'is_archived' => 'nullable|boolean',
            'published_at' => 'nullable|date_format:Y-m-d H:i:s',
            'archived_at' => 'nullable|date_format:Y-m-d H:i:s',
            
            // Metadata
            'metadata' => 'nullable|json',
        ];
    }
}
