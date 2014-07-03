package controllers

import (
    "github.com/revel/revel"
    "github.com/jsime/automa/app/models"
)

type Posts struct {
    App
}

func (c Posts) Index() revel.Result {
    var posts []models.Post
    _, err := Dbm.Select(&posts, "select * from posts where published_at is not null order by published_at desc")

    if err != nil {
        panic(err)
    }

    return c.Render(posts)
}
