<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use App\Models\Event;
use App\Models\User;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Event>
 */
class EventFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'title' => $this->faker->sentence,
            'slug' => $this->faker->slug,
            'description' => $this->faker->paragraph,
            'start_time' => $this->faker->dateTimeBetween('+1 week', '+1 month'),
            'end_time' => $this->faker->dateTimeBetween('+1 month', '+2 months'),
            'timezone' => $this->faker->timezone,
            'event_type' => $this->faker->randomElement(['online', 'in-person']),
            'location' => $this->faker->address,
            'city' => $this->faker->city,
            'meeting_url' => $this->faker->url,
            'thumbnail_url' => $this->faker->imageUrl,
            'category' => $this->faker->word,
            'capacity' => $this->faker->numberBetween(50, 500),
            'ticket_price' => $this->faker->randomFloat(2, 10, 100),
            'status' => $this->faker->randomElement(['draft', 'published', 'cancelled']),
            'is_public' => $this->faker->boolean,
            'is_archived' => false,
            'published_at' => null,
            'archived_at' => null,
            'metadata' => ['key' => 'value'],
            'created_by' => function () {
                return User::firstOrCreate(
                    ['email' => 'admin@example.com'],
                    ['name' => 'Admin User', 'password' => bcrypt('password')]
                )->id;
            },
        ];
    }
}
