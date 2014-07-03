package models

import (
    "time"
)

type UserPref struct {
    PrefID      int
    UserID      User
    Name        string
    Value       string
    CreatedAt   time.Time
    UpdatedAt   time.Time
}

