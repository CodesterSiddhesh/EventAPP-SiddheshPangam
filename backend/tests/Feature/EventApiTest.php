<?php

namespace Tests\Feature;

use App\Models\Event;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class EventApiTest extends TestCase
{
    use RefreshDatabase;

    protected $user;

    protected function setUp(): void
    {
        parent::setUp();

        $this->user = User::factory()->create();
        $this->actingAs($this->user, 'sanctum');
    }

    public function test_index_returns_events_list()
    {
        Event::factory()->count(3)->create();

        $response = $this->getJson('/api/events');

        $response->assertStatus(200)
            ->assertJsonStructure(['data', 'links', 'meta'])
            ->assertJsonCount(3, 'data');
    }

    public function test_store_creates_event()
    {
        $payload = [
            'title' => 'New Event',
            'slug' => 'new-event',
            'description' => 'A test event.',
            'start_time' => now()->addDays(3)->format('Y-m-d H:i:s'),
            'end_time' => now()->addDays(4)->format('Y-m-d H:i:s'),
            'timezone' => 'UTC',
            'event_type' => 'in-person',
            'location' => 'Test Venue',
            'city' => 'Test City',
            'meeting_url' => 'https://example.com/meet',
            'thumbnail_url' => 'https://example.com/image.png',
            'category' => 'Workshop',
            'capacity' => 100,
            'ticket_price' => 25.00,
            'status' => 'draft',
            'is_public' => true,
            'is_archived' => false,
            'metadata' => json_encode(['source' => 'api']),
        ];

        $response = $this->postJson('/api/events', $payload);

        $response->assertStatus(201)
            ->assertJsonPath('data.title', 'New Event')
            ->assertJsonPath('data.city', 'Test City')
            ->assertJsonPath('data.status', 'draft');

        $this->assertDatabaseHas('events', [
            'title' => 'New Event',
            'city' => 'Test City',
            'created_by' => $this->user->id,
        ]);
    }

    public function test_show_returns_event_details()
    {
        $event = Event::factory()->create();

        $response = $this->getJson('/api/events/' . $event->id);

        $response->assertStatus(200)
            ->assertJsonPath('data.id', $event->id)
            ->assertJsonPath('data.title', $event->title);
    }

    public function test_update_modifies_event()
    {
        $event = Event::factory()->create(['status' => 'draft']);

        $payload = [
            'title' => 'Updated Event Title',
            'status' => 'published',
        ];

        $response = $this->putJson('/api/events/' . $event->id, $payload);

        $response->assertStatus(200)
            ->assertJsonPath('data.title', 'Updated Event Title')
            ->assertJsonPath('data.status', 'published');

        $this->assertDatabaseHas('events', [
            'id' => $event->id,
            'title' => 'Updated Event Title',
            'status' => 'published',
        ]);
    }

    public function test_destroy_deletes_event()
    {
        $event = Event::factory()->create();

        $response = $this->deleteJson('/api/events/' . $event->id);

        $response->assertStatus(200)
            ->assertJson(['message' => 'Event deleted successfully']);

        $this->assertSoftDeleted('events', ['id' => $event->id]);
    }
}
