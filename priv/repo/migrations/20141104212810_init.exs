defmodule YappCast.Repo.Migrations.Init do
  use Ecto.Migration

  def up do
    [
      """
      CREATE TABLE IF NOT EXISTS users (
        id serial PRIMARY KEY, 
        email varchar(255) UNIQUE NOT NULL,
        password varchar NOT NULL
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS companies (
        id serial PRIMARY KEY, 
        name varchar(255) UNIQUE NOT NULL, 
        slug varchar(255) UNIQUE NOT NULL, 
        user_id int references users(id) ON DELETE CASCADE 
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS podcasts (
        id serial PRIMARY KEY, 
        name varchar(255) NOT NULL, 
        slug varchar(255) NOT NULL, 
        cover_url varchar(255) NOT NULL, 
        company_id int references companies(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS episodes (
        id serial PRIMARY KEY, 
        name varchar(255) NOT NULL, 
        slug varchar(255) NOT NULL, 
        cover_url varchar(255), 
        media_url varchar(255), 
        published bit NOT NULL, 
        podcast_id int references podcasts(id) ON DELETE CASCADE
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS user_company_permissions (
        id serial PRIMARY KEY, 
        user_id int references users(id) ON DELETE CASCADE,
        company_id int references companies(id) ON DELETE CASCADE,
        can_add bit NOT NULL, 
        can_edit bit NOT NULL, 
        can_delete bit NOT NULL
      )
      """,
      """
      CREATE TABLE IF NOT EXISTS user_podcast_permissions (
        id serial PRIMARY KEY, 
        user_id int references users(id) ON DELETE CASCADE,
        podcast_id int references companies(id) ON DELETE CASCADE,
        can_view bit NOT NULL, 
        can_add bit NOT NULL, 
        can_edit bit NOT NULL, 
        can_delete bit NOT NULL
      )
      """,
      "CREATE UNIQUE INDEX users_email_idx ON users ((lower(email)))",

      "CREATE UNIQUE INDEX companies_name_idx ON companies ((lower(name)))",
      "CREATE UNIQUE INDEX companies_slug_idx ON companies ((lower(slug)))",
      "CREATE INDEX companies_user_id_idx ON companies (user_id)",

      "CREATE INDEX podcasts_name_idx ON podcasts ((lower(name)))",
      "CREATE INDEX podcasts_slug_idx ON podcasts ((lower(slug)))",
      "CREATE INDEX podcasts_company_id_idx ON podcasts (company_id)",

      "CREATE INDEX episodes_name_idx ON episodes ((lower(name)))",
      "CREATE INDEX episodes_slug_idx ON episodes ((lower(slug)))",
      "CREATE INDEX episodes_podcast_idx ON episodes (podcast_id)",

      "CREATE INDEX ucp_user_id_idx ON user_company_permissions (user_id)",
      "CREATE INDEX ucp_company_id_idx ON user_company_permissions (company_id)",

      "CREATE INDEX upp_user_id_idx ON user_podcast_permissions (user_id)",
      "CREATE INDEX upp_podcast_id_idx ON user_podcast_permissions (podcast_id)"
    ]
  end

  def down do
    [
      "DROP INDEX IF EXISTS users_email_idx",
      "DROP INDEX IF EXISTS companies_name_idx",
      "DROP INDEX IF EXISTS companies_slug_idx",
      "DROP INDEX IF EXISTS companies_user_id_idx",
      "DROP INDEX IF EXISTS podcasts_name_idx",
      "DROP INDEX IF EXISTS podcasts_slug_idx",
      "DROP INDEX IF EXISTS podcasts_company_id_idx",
      "DROP INDEX IF EXISTS episodes_name_idx",
      "DROP INDEX IF EXISTS episodes_slug_idx",
      "DROP INDEX IF EXISTS episodes_podcast_idx",
      "DROP INDEX IF EXISTS ucp_user_id_idx",
      "DROP INDEX IF EXISTS ucp_company_id_idx",
      "DROP INDEX IF EXISTS upp_user_id_idx",
      "DROP INDEX IF EXISTS upp_podcast_id_idx",

      "DROP TABLE IF EXISTS user_podcast_permissions",
      "DROP TABLE IF EXISTS user_company_permissions",
      "DROP TABLE IF EXISTS episodes",
      "DROP TABLE IF EXISTS podcasts",
      "DROP TABLE IF EXISTS companies",
      "DROP TABLE IF EXISTS users",
    ]
  end
end
