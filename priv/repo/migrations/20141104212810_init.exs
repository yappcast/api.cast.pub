defmodule YappCast.Repo.Migrations.Init do
  use Ecto.Migration

  def up do
    [
      """
      CREATE TABLE IF NOT EXISTS users (
        id serial PRIMARY KEY, 
        email varchar(255) UNIQUE NOT NULL,
        password varchar NOT NULL,
        name varchar(255) NOT NULL
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS podcasts (
        id serial PRIMARY KEY, 
        title varchar(255) NOT NULL,
        link varchar(255), 
        copyright varchar(255), 
        author varchar(255), 
        block bool NOT NULL,
        image_url varchar(255),
        explicit bool NOT NULL,
        complete bool NOT NULL,
        new_feed_url varchar(255), 
        owner varchar(255), 
        owner_email varchar(255), 
        subtitle varchar(255), 
        summary varchar, 
        user_id int references users(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS episodes (
        id serial PRIMARY KEY, 
        title varchar(255) NOT NULL, 
        publish_date timestamp,
        author varchar(255),
        block bool NOT NULL,
        image_url varchar(255),
        duration varchar(255),
        explicit bool NOT NULL,
        is_closed_captioned bool NOT NULL,
        "order" integer,
        subtitle varchar(255), 
        summary varchar, 
        media_url varchar(255),
        media_content_length integer,
        media_mime_type varchar(255),
        file_name varchar(255),
        podcast_id int references podcasts(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS categories (
        id serial PRIMARY KEY, 
        title varchar(255) NOT NULL, 
        podcast_id int references podcasts(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS sub_categories (
        id serial PRIMARY KEY, 
        title varchar(255) NOT NULL, 
        category_id int references categories(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS podcast_categories (
        id serial PRIMARY KEY, 
        podcast_id int references podcasts(id) ON DELETE CASCADE,
        category_id int references categories(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS podcast_sub_categories (
        id serial PRIMARY KEY, 
        podcast_category_id int references podcast_categories(id) ON DELETE CASCADE,
        sub_category_id int references sub_categories(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS podcast_permission_groups (
        id serial PRIMARY KEY,
        title varchar(255) NOT NULL,
        podcast_id int references podcasts(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS podcast_permission_group_members (
        id serial PRIMARY KEY, 
        group_id int references podcast_permission_groups(id) ON DELETE CASCADE,
        user_id int references users(id) ON DELETE CASCADE
      )
      """,
      "CREATE UNIQUE INDEX users_email_idx ON users ((lower(email)))",

      "CREATE UNIQUE INDEX podcasts_title_idx ON podcasts (user_id, (lower(title)))",
      "CREATE INDEX podcasts_user_id_idx ON podcasts (user_id)",

      "CREATE UNIQUE INDEX episodes_title_idx ON episodes (podcast_id, (lower(title)))",
      "CREATE INDEX episodes_podcast_idx ON episodes (podcast_id)",

      "CREATE INDEX ppg_podcast_id_idx ON podcast_permission_groups (podcast_id)",
      "CREATE INDEX ppgm_group_id_idx ON podcast_permission_group_members (group_id)",
      "CREATE INDEX ppgm_user_id_idx ON podcast_permission_group_members (user_id)",

      "CREATE INDEX category_podcast_id_idx ON categories (podcast_id)",
      "CREATE INDEX sub_category_category_id_idx ON sub_categories (category_id)"
    ]
  end

  def down do
    [
      "DROP INDEX IF EXISTS users_email_idx",

      "DROP INDEX IF EXISTS podcasts_title_idx",
      "DROP INDEX IF EXISTS podcasts_user_id_idx",

      "DROP INDEX IF EXISTS episodes_title_idx",
      "DROP INDEX IF EXISTS episodes_podcast_idx",
      
      "DROP INDEX IF EXISTS ppg_podcast_id_idx",
      "DROP INDEX IF EXISTS ppgm_group_id_idx",
      "DROP INDEX IF EXISTS ppgm_user_id_idx",

      "DROP INDEX IF EXISTS category_podcast_id_idx",
      "DROP INDEX IF EXISTS sub_category_category_id_idx",

      "DROP TABLE IF EXISTS podcast_permission_group_members",
      "DROP TABLE IF EXISTS podcast_permission_groups",
      "DROP TABLE IF EXISTS episodes",
      "DROP TABLE IF EXISTS podcast_sub_categories",
      "DROP TABLE IF EXISTS podcast_categories",
      "DROP TABLE IF EXISTS sub_categories",
      "DROP TABLE IF EXISTS categories",
      "DROP TABLE IF EXISTS podcasts",
      "DROP TABLE IF EXISTS users"
    ]
  end
end
