<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Resources\EventResource;
use App\Services\EventService;
use App\Models\Event;
use App\Repositories\EventRepository;
use App\Http\Requests\StoreEventRequest;
use App\Http\Requests\UpdateEventRequest;

/**
 * @group Events
 *
 * APIs for managing events
 */
class EventController extends Controller
{
    public function __construct(protected  EventService $eventService, protected EventRepository $eventRepo)
    {
    }

    /**
     * Get all events
     *
     * Get a paginated list of events. Supports filtering by status, archive status, and search.
     *
     * @authenticated
     * @queryParam page integer The page number. Example: 1
     * @queryParam per_page integer Number of items per page. Example: 15
     * @queryParam status string Filter by status (draft, published, archived). Example: published
     * @queryParam archived boolean Filter by archive status. Example: false
     * @queryParam search string Search in title and description. Example: conference
     *
     * @response 200 {
     *   "data": [
     *     {
     *       "id": 1,
     *       "title": "Laravel Conference",
     *       "description": "Annual Laravel conference",
     *       "start_date": "2024-06-15",
     *       "end_date": "2024-06-17",
     *       "location": "San Francisco",
     *       "status": "published",
     *       "archived": false,
     *       "created_by": 1,
     *       "created_at": "2024-01-01T00:00:00.000000Z",
     *       "updated_at": "2024-01-01T00:00:00.000000Z"
     *     }
     *   ],
     *   "links": {...},
     *   "meta": {...}
     * }
     */
    public function index()
    {
        $events = $this->eventRepo->paginate(request()->all());
        return EventResource::collection($events);
    }

    /**
     * Create a new event
     *
     * Create a new event with the provided data.
     *
     * @authenticated
     * 
     * @bodyParam title string required The event title. Example: Laravel Conference 2024
     * @bodyParam description string required The event description. Example: Annual Laravel conference
     * @bodyParam start_date date required The start date. Example: 2024-06-15
     * @bodyParam end_date date required The end date. Example: 2024-06-17
     * @bodyParam location string required The event location. Example: San Francisco, CA
     * @bodyParam status string The event status. Must be one of: draft, published, archived. Example: draft
     * @bodyParam archived boolean Whether the event is archived. Example: false
     *
     * @response 201 {
     *   "data": {
     *     "id": 1,
     *     "title": "Laravel Conference 2024",
     *     "description": "Annual Laravel conference",
     *     "start_date": "2024-06-15",
     *     "end_date": "2024-06-17",
     *     "location": "San Francisco, CA",
     *     "status": "draft",
     *     "archived": false,
     *     "created_by": 1,
     *     "created_at": "2024-01-01T00:00:00.000000Z",
     *     "updated_at": "2024-01-01T00:00:00.000000Z"
     *   }
     * }
     */
    public function store(StoreEventRequest $request)
    {
        $data = $request->validated();
        $data['created_by'] = auth()->id();

        $event = $this->eventService->createEvent($data);
        return new EventResource($event);
    }

    /**
     * Get a specific event
     *
     * Get detailed information about a specific event.
     * 
     * @authenticated
     *
     * @urlParam event integer required The event ID. Example: 1
     *
     * @response 200 {
     *   "data": {
     *     "id": 1,
     *     "title": "Laravel Conference 2024",
     *     "description": "Annual Laravel conference",
     *     "start_date": "2024-06-15",
     *     "end_date": "2024-06-17",
     *     "location": "San Francisco, CA",
     *     "status": "published",
     *     "archived": false,
     *     "created_by": 1,
     *     "created_at": "2024-01-01T00:00:00.000000Z",
     *     "updated_at": "2024-01-01T00:00:00.000000Z"
     *   }
     * }
     */
    public function show(Event $event)
    {
        return new EventResource($event);
    }

    /**
     * Update an event
     *
     * Update an existing event with new data.
     * 
     * @authenticated
     *
     * @urlParam event integer required The event ID. Example: 1
     * @bodyParam title string The event title. Example: Updated Laravel Conference
     * @bodyParam description string The event description. Example: Updated description
     * @bodyParam start_date date The start date. Example: 2024-06-16
     * @bodyParam end_date date The end date. Example: 2024-06-18
     * @bodyParam location string The event location. Example: Los Angeles, CA
     * @bodyParam status string The event status. Must be one of: draft, published, archived. Example: published
     * @bodyParam archived boolean Whether the event is archived. Example: true
     *
     * @response 200 {
     *   "data": {
     *     "id": 1,
     *     "title": "Updated Laravel Conference",
     *     "description": "Updated description",
     *     "start_date": "2024-06-16",
     *     "end_date": "2024-06-18",
     *     "location": "Los Angeles, CA",
     *     "status": "published",
     *     "archived": true,
     *     "created_by": 1,
     *     "created_at": "2024-01-01T00:00:00.000000Z",
     *     "updated_at": "2024-01-01T00:00:00.000000Z"
     *   }
     * }
     */
    public function update(UpdateEventRequest $request, Event $event)
    {
        $event = $this->eventService->updateEvent($event, $request->validated());
        return new EventResource($event);
    }

    /**
     * Delete an event
     *
     * Delete a specific event.
     *
     * @authenticated
     * @urlParam event integer required The event ID. Example: 1
     *
     * @response 200 {
     *   "message": "Event deleted successfully"
     * }
     */
    public function destroy(Event $event)
    {
        $this->eventService->deleteEvent($event);
        return response()->json(['message' => 'Event deleted successfully']);
    }
}
