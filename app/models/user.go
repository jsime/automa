package models

import (
    "time"
)

type User struct {
    UserID       int
    UserName     string
    Name         string
    UrlName      string
    Email        string
    Password     string
    PasswordHint string
    VerifyToken  string
    VerifiedAt   time.Time
    CreatedAt    time.Time
    UpdatedAt    time.Time
}

