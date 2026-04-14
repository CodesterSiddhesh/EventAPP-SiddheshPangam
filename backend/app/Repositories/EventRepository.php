<?php

namespace App\Repositories;

use App\Models\Event;
use Illuminate\Support\Str;

class EventRepository
{
    public function paginate(array $filters = [], int $perPage = 15)
    {
        $query = Event::query();

        if (isset($filters['status'])) {
            $query->where('status', $filters['status']);
        }

        if (isset($filters['is_archived'])) {
            $query->where('is_archived', $filters['is_archived']);
        }

        if (isset($filters['created_by'])) {
            $query->where('created_by', $filters['created_by']);
        }

        if (isset($filters['city'])) {
            $query->where('city', 'like', '%' . $filters['city'] . '%');
        }

        return $query->orderBy('start_time', 'desc')->paginate($perPage);
    }


    public function create(array $data): Event
    {
        $data['slug'] = Str::slug($data['title']) . '-' . Str::random(6);
        $data['created_by'] = auth()->id();
        return Event::create($data);
    }

    public function update(Event $event, array $data): bool
    {
        if (isset($data['title']) && $data['title'] !== $event->title) {
            $data['slug'] = Str::slug($data['title']) . '-' . Str::random(6);
        }
        return $event->update($data);
    }

    public function delete(Event $event): bool
    {
        return $event->delete();
    }
}