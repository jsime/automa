package models

import (
    "database/sql"
    "github.com/revel/revel"
    "github.com/lib/pq"
    "github.com/coopernurse/gorp"
    "strings"
    "time"
)

type Post struct {
    PostId      int            `db:"post_id"`
    Title       string         `db:"title"`
    UrlTitle    string         `db:"url_title"`
    Summary     string         `db:"summary"`
    AboveFold   string         `db:"above_fold"`
    BelowFold   sql.NullString `db:"below_fold"`
    PublishedAt pq.NullTime    `db:"published_at"`
    CreatedAt   time.Time      `db:"created_at"`
    UpdatedAt   pq.NullTime    `db:"updated_at"`
}

const (
    DATETIME_FORMAT = "Jan 2, 2006 at 3:04pm MST"
    DATE_FORMAT     = "Jan 2, 2006"
    TIME_FORMAT     = "3:04pm MST"
)

func (p Post) Validate(v *revel.Validation) {
    v.Required(p.Title)
    v.Required(p.UrlTitle)
    v.Required(p.AboveFold)
    v.Required(p.CreatedAt)
}

func (p *Post) PreInsert(_ gorp.SqlExecutor) error {
    p.UrlTitle = p.GenerateUrlTitle(p.Title)
    return nil
}

func (p Post) IsUpdated() bool {
    if p.UpdatedAt.Valid && p.UpdatedAt.Time.After(p.PublishedAt.Time) {
        return true
    }
    return false
}

func (p Post) PublishedStr(form string) string {
    switch strings.ToLower(form) {
        case "date": return p.PublishedStrDate()
        case "time": return p.PublishedStrTime()
        default: return p.PublishedStrDateTime()
    }
    return ""
}

func (p Post) PublishedStrDate() string {
    if p.PublishedAt.Valid {
        return p.PublishedAt.Time.Format(DATE_FORMAT)
    }
    return ""
}

func (p Post) PublishedStrTime() string {
    if p.PublishedAt.Valid {
        return p.PublishedAt.Time.Format(TIME_FORMAT)
    }
    return ""
}

func (p Post) PublishedStrDateTime() string {
    if p.PublishedAt.Valid {
        return p.PublishedAt.Time.Format(DATETIME_FORMAT)
    }
    return ""
}

func (p Post) GenerateUrlTitle(title string) string {
    // TODO:
    //  - remove stopwords & punctuation
    //  - replace all symbols and whitespace with dashes
    //  - reduce multiple adjacent dashes to singles
    //  - trim length, preferably favoring full word at end
    title = strings.ToLower(title)

    return title
}
