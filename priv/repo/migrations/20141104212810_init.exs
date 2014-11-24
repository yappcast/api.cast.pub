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
      CREATE TABLE IF NOT EXISTS companies (
        id serial PRIMARY KEY, 
        title varchar(255) UNIQUE NOT NULL, 
        slug varchar(255) UNIQUE NOT NULL, 
        user_id int references users(id) ON DELETE CASCADE 
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
        slug varchar(255) NOT NULL,  
        company_id int references companies(id) ON DELETE CASCADE
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
        slug varchar(255) NOT NULL, 
        media_url varchar(255),
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
      CREATE TABLE IF NOT EXISTS company_permission_groups (
        id serial PRIMARY KEY, 
        title varchar(255) NOT NULL,
        company_id int references companies(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS company_permission_group_members (
        id serial PRIMARY KEY, 
        group_id int references company_permission_groups(id) ON DELETE CASCADE,
        user_id int references users(id) ON DELETE CASCADE
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

      "CREATE UNIQUE INDEX companies_title_idx ON companies ((lower(title)))",
      "CREATE UNIQUE INDEX companies_slug_idx ON companies ((lower(slug)))",
      "CREATE INDEX companies_user_id_idx ON companies (user_id)",

      "CREATE INDEX podcasts_title_idx ON podcasts ((lower(title)))",
      "CREATE INDEX podcasts_slug_idx ON podcasts ((lower(slug)))",
      "CREATE INDEX podcasts_company_id_idx ON podcasts (company_id)",

      "CREATE INDEX episodes_title_idx ON episodes ((lower(title)))",
      "CREATE INDEX episodes_slug_idx ON episodes ((lower(slug)))",
      "CREATE INDEX episodes_podcast_idx ON episodes (podcast_id)",

      "CREATE INDEX cpg_company_id_idx ON company_permission_groups (company_id)",
      "CREATE INDEX cpgm_group_id_idx ON company_permission_group_members (group_id)",
      "CREATE INDEX cpgm_user_id_idx ON company_permission_group_members (user_id)",

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

      "DROP INDEX IF EXISTS companies_title_idx",
      "DROP INDEX IF EXISTS companies_slug_idx",
      "DROP INDEX IF EXISTS companies_user_id_idx",

      "DROP INDEX IF EXISTS podcasts_title_idx",
      "DROP INDEX IF EXISTS podcasts_slug_idx",
      "DROP INDEX IF EXISTS podcasts_company_id_idx",

      "DROP INDEX IF EXISTS episodes_title_idx",
      "DROP INDEX IF EXISTS episodes_slug_idx",
      "DROP INDEX IF EXISTS episodes_podcast_idx",

      "DROP INDEX IF EXISTS cpg_company_id_idx",
      "DROP INDEX IF EXISTS cpgm_group_id_idx",
      "DROP INDEX IF EXISTS cpgm_user_id_idx",
      
      "DROP INDEX IF EXISTS ppg_podcast_id_idx",
      "DROP INDEX IF EXISTS ppgm_group_id_idx",
      "DROP INDEX IF EXISTS ppgm_user_id_idx",

      "DROP INDEX IF EXISTS category_podcast_id_idx",
      "DROP INDEX IF EXISTS sub_category_category_id_idx",

      "DROP TABLE IF EXISTS podcast_permission_group_members",
      "DROP TABLE IF EXISTS podcast_permission_groups",
      "DROP TABLE IF EXISTS company_permission_group_members",
      "DROP TABLE IF EXISTS company_permission_groups",
      "DROP TABLE IF EXISTS episodes",
      "DROP TABLE IF EXISTS sub_categories",
      "DROP TABLE IF EXISTS categories",
      "DROP TABLE IF EXISTS podcasts",
      "DROP TABLE IF EXISTS companies",
      "DROP TABLE IF EXISTS users"
    ]
  end
end
