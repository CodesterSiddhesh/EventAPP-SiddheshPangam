<?php

namespace App\Services;

use App\Models\Event;
use App\Repositories\EventRepository;
class EventService
{
    protected $eventRepo;

    public function __construct(EventRepository $eventRepo)
    {
        $this->eventRepo = $eventRepo;
    }

    public function createEvent(array $data): Event
    {
        return $this->eventRepo->create($data);
    }

    public function updateEvent(Event $event, array $data): Event
    {
        $this->eventRepo->update($event, $data);

        return $event->refresh();
    }

    public function deleteEvent(Event $event): bool
    {
        return $this->eventRepo->delete($event);
    }

    public function paginateEvents(array $filters = [], int $perPage = 15)
    {
        return $this->eventRepo->paginate($filters, $perPage);
    }

}