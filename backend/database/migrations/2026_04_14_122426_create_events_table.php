<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('events', function (Blueprint $table) {
            $table->id();

            // Basic Information
            $table->string('title');
            $table->string('slug')->unique();
            $table->text('description')->nullable();
            
            // Event Scheduling
            $table->dateTime('start_time');
            $table->dateTime('end_time');
            $table->string('timezone')->default('UTC');
            
            // Location & Event Type
            $table->enum('event_type', ['in-person', 'online', 'hybrid'])->default('in-person');
            $table->string('location')->nullable();
            $table->string('city')->nullable();
            
            // Online Event Details
            $table->string('meeting_url')->nullable();
            
            // Media & Display
            $table->string('thumbnail_url')->nullable();
            $table->string('category')->nullable();
            
            // Capacity & Registration
            $table->integer('capacity')->nullable();
            $table->decimal('ticket_price', 10, 2)->nullable();
            
            // Visibility & Status
            $table->enum('status', ['draft', 'published', 'cancelled'])->default('draft');
            $table->boolean('is_public')->default(true);
            $table->boolean('is_archived')->default(false);
            $table->dateTime('published_at')->nullable();
            $table->dateTime('archived_at')->nullable();
            
            // Metadata
            $table->json('metadata')->nullable();
            
            // Relationships
            $table->foreignId('created_by')->constrained('users')->onDelete('cascade');
            
            // Timestamps
            $table->timestamps();
            $table->softDeletes();
            
            // Indexes for performance
            $table->index('status');
            $table->index('is_archived');
            $table->index('created_by');
            $table->index('city');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('events');
    }
};
