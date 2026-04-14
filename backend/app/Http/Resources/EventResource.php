<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class EventResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'description' => $this->description,
            'start_time' => $this->start_time,
            'end_time' => $this->end_time,
            'timezone' => $this->timezone,
            'event_type' => $this->event_type,
            'location' => $this->location,
            'city' => $this->city,
            'meeting_url' => $this->meeting_url,
            'thumbnail_url' => $this->thumbnail_url,
            'category' => $this->category,
            'capacity' => $this->capacity,
            'ticket_price' => $this->ticket_price,
            'status' => $this->status,
            'is_public' => $this->is_public,
            'is_archived' => $this->is_archived,
            'published_at' => $this->published_at,
            'archived_at' => $this->archived_at,
            'metadata' => is_string($this->metadata) ? json_decode($this->metadata, true) : $this->metadata,
        ];
    }
}
