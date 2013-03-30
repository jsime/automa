begin;

create table users (
    user_id     serial not null,
    email       text not null,
    name        text not null,
    created_at  timestamp with time zone not null default now(),
    updated_at  timestamp with time zone
);
alter table users add primary key (user_id);
create unique index users_lower_email_idx on users (lower(email));

create table tags (
    tag_id      serial not null,
    name        text not null,
    name_url    text not null
);
alter table tags add primary key (tag_id);
create unique index tags_lower_name_idx on tags (lower(name));
create unique index tags_lower_name_url_idx on tags (lower(name_url));

create table posts (
    post_id         serial not null,
    title           text,
    title_url       text,
    summary         text,
    content_above   text,
    content_below   text,
    created_at      timestamp with time zone not null default now(),
    updated_at      timestamp with time zone,
    posted_at       timestamp with time zone
);
alter table posts add primary key (post_id);
create index posts_lower_title_url_idx on posts (lower(title_url));
create index posts_created_at_idx on posts (created_at);
create index posts_updated_at_idx on posts (updated_at);
create index posts_posted_at_idx on posts (posted_at);
alter table posts add constraint required_fields check (posted_at is null or (title is not null and title_url is not null and content_above is not null));

create table post_authors (
    post_id integer not null,
    user_id integer not null
);
alter table post_authors add primary key (post_id, user_id);
create index post_authors_user_id_idx on post_authors (user_id);
alter table post_authors add foreign key (post_id) references posts (post_id) on update cascade on delete cascade;
alter table post_authors add foreign key (user_id) references users (user_id) on update cascade on delete cascade;

create table post_tags (
    post_id integer not null,
    tag_id  integer not null
);
alter table post_tags add primary key (post_id, tag_id);
create index post_tags_tag_id_idx on post_tags (tag_id);
alter table post_tags add foreign key (post_id) references posts (post_id) on update cascade on delete cascade;
alter table post_tags add foreign key (tag_id) references tags (tag_id) on update cascade on delete cascade;

commit;
