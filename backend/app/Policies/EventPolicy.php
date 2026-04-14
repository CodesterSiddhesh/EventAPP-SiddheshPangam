<?php

namespace App\Policies;

use App\Models\User;

class EventPolicy
{
    public function create(User $user): bool
    {
        return $user->hasRole('admin');
    }

    public function update(User $user, $event): bool
    {
        return $user->hasRole('admin') || $event->created_by === $user->id;
    }

    public function delete(User $user, $event): bool
    {
        return $user->hasRole('admin') || $event->created_by === $user->id;
    }
    
}
