begin;

drop schema if exists automa cascade;
create schema automa authorization automa;

set search_path to automa;

create table users (
    user_id         serial not null primary key,
    username        text not null,
    fullname        text not null,
    url_name        text not null,
    email           text not null,
    password        text not null,
    password_hint   text not null,
    verify_token    text not null,
    verified_at     timestamp with time zone,
    created_at      timestamp with time zone not null default now(),
    updated_at      timestamp with time zone
);

create unique index users_lower_username_idx on users (lower(username));
create unique index users_lower_email_idx on users (lower(email));

create table user_preferences (
    preference_id       serial not null primary key,
    user_id             integer not null,
    preference_name     text not null,
    preference_value    text not null,
    created_at          timestamp with time zone not null default now(),
    updated_at          timestamp with time zone
);

create index user_preferences_user_id_idx on user_preferences (user_id);

alter table user_preferences add foreign key (user_id) references users (user_id) on update cascade on delete cascade;

create table roles (
    role_id     serial not null primary key,
    role_name   text not null,
    description text not null
);

create unique index roles_lower_role_name_idx on roles (lower(role_name));

create table user_roles (
    user_id integer not null,
    role_id integer not null
);

alter table user_roles add primary key (user_id, role_id);

create index user_roles_role_id_idx on user_roles (role_id);

alter table user_roles add foreign key (user_id) references users (user_id) on update cascade on delete cascade;
alter table user_roles add foreign key (role_id) references roles (role_id) on update cascade on delete cascade;

create table posts (
    post_id         serial not null primary key,
    title           text not null,
    url_title       text not null,
    summary         text not null,
    above_fold      text not null,
    below_fold      text,
    published_at    timestamp with time zone,
    created_at      timestamp with time zone not null default now(),
    updated_at      timestamp with time zone
);

create index posts_url_title_idx on posts (url_title);
create index posts_published_at_idx on posts (published_at);

create table sections (
    section_id      serial not null primary key,
    section_name    text not null,
    url_name        text not null
);

create unique index sections_url_name_idx on sections (url_name);

create table tags (
    tag_id      serial not null primary key,
    tag_name    text not null,
    url_name    text not null
);

create unique index tags_url_name_idx on tags (url_name);

create table post_authors (
    post_id     integer not null,
    author_id   integer not null
);

alter table post_authors add primary key (post_id, author_id);

create index post_authors_author_id_idx on post_authors (author_id);

alter table post_authors add foreign key (post_id) references posts (post_id) on update cascade on delete cascade;
alter table post_authors add foreign key (author_id) references users (user_id) on update cascade on delete cascade;

create table post_sections (
    post_id     integer not null,
    section_id  integer not null
);

alter table post_sections add primary key (post_id, section_id);

create index post_sections_section_id_idx on post_sections (section_id);

alter table post_sections add foreign key (post_id) references posts (post_id) on update cascade on delete cascade;
alter table post_sections add foreign key (section_id) references sections (section_id) on update cascade on delete cascade;

create table post_tags (
    post_id integer not null,
    tag_id  integer not null
);

alter table post_tags add primary key (post_id, tag_id);

create index post_tags_tag_id_idx on post_tags (tag_id);

alter table post_tags add foreign key (post_id) references posts (post_id) on update cascade on delete cascade;
alter table post_tags add foreign key (tag_id) references tags (tag_id) on update cascade on delete cascade;

create table comments (
    comment_id          serial not null primary key,
    user_id             integer not null,
    post_id             integer not null,
    parent_comment_id   integer,
    comment_body        text not null,
    deleted_at          timestamp with time zone,
    created_at          timestamp with time zone not null default now(),
    updated_at          timestamp with time zone
);

create index comments_user_id_idx on comments (user_id);
create index comments_post_id_Idx on comments (post_id);
create index comments_parent_comment_id_idx on comments (parent_comment_id);

alter table comments add foreign key (user_id) references users (user_id) on update cascade;
alter table comments add foreign key (post_id) references posts (post_id) on update cascade;
alter table comments add foreign key (parent_comment_id) references comments (comment_id) on update cascade;

commit;
