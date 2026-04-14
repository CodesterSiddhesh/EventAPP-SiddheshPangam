<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Event extends Model
{
    use HasFactory, SoftDeletes;

    protected $fillable = [
        'title',
        'slug',
        'description',
        'start_time',
        'end_time',
        'timezone',
        'event_type',
        'location',
        'city',
        'meeting_url',
        'thumbnail_url',
        'category',
        'capacity',
        'ticket_price',
        'status',
        'is_public',
        'is_archived',
        'published_at',
        'archived_at',
        'metadata',
        'created_by',
    ];

    protected $casts = [
        'start_time' => 'datetime',
        'end_time' => 'datetime',
        'published_at' => 'datetime',
        'archived_at' => 'datetime',
        'is_public' => 'boolean',
        'is_archived' => 'boolean',
        'metadata' => 'json',
    ];

    public function creator()
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    // Publish/Archive Methods
    public function publish()
    {
        return $this->update([
            'status' => 'published',
            'published_at' => now(),
        ]);
    }

    public function archive()
    {
        return $this->update([
            'is_archived' => true,
            'archived_at' => now(),
        ]);
    }

    public function unarchive()
    {
        return $this->update([
            'is_archived' => false,
            'archived_at' => null,
        ]);
    }

    // Scope Methods
    public function scopePublished($query)
    {
        return $query->where('status', 'published')->where('published_at', '<=', now());
    }

    public function scopeDraft($query)
    {
        return $query->where('status', 'draft');
    }

    public function scopeArchived($query)
    {
        return $query->where('is_archived', true);
    }

    public function scopeActive($query)
    {
        return $query->where('is_archived', false)->where('status', 'published');
    }

    public function scopePublic($query)
    {
        return $query->where('is_public', true);
    }

    public function scopeUpcoming($query)
    {
        return $query->where('start_time', '>', now());
    }

    public function scopePast($query)
    {
        return $query->where('end_time', '<', now());
    }

    public function scopeOnline($query)
    {
        return $query->whereIn('event_type', ['online', 'hybrid']);
    }

    public function scopeInPerson($query)
    {
        return $query->whereIn('event_type', ['in-person', 'hybrid']);
    }

    // Check Methods
    public function isPublished()
    {
        return $this->status === 'published' && $this->published_at && $this->published_at <= now();
    }

    public function isDraft()
    {
        return $this->status === 'draft';
    }

    public function isArchived()
    {
        return $this->is_archived === true;
    }

    public function isUpcoming()
    {
        return $this->start_time > now();
    }

    public function isPast()
    {
        return $this->end_time < now();
    }

    public function isOngoing()
    {
        return $this->start_time <= now() && $this->end_time >= now();
    }

    public function isOnline()
    {
        return in_array($this->event_type, ['online', 'hybrid']);
    }

    public function availableCapacity()
    {
        return $this->capacity ? ($this->capacity - $this->current_attendance ?? 0) : null;
    }

}
