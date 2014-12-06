# CastPub

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Rename config/<env>.exs.example to config/<env>.exs (where <env> is the environment)
3. Create Database with `mix ecto.create CastPub.Repo`
4. Run migrations with `mix ecto.migrate CastPub.Repo`
5. Start Phoenix router with `mix phoenix.start`

Now you can visit `localhost:4000` from your browser.

# Migrations
TO create a migration, do: `mix ecto.gen.migration CastPub.Repo <migration_name>`
To run migrations, do: `mix ecto.migrate CastPub.Repo`

do `mix help` to see all the commands that are available


User signs up
User creates Company. Company essentially is a group of podcasts
User can invite other users to Company
User can give Permissions to Podcast/Company for invited Users

Data saved on user's own S3 instance (cover art, episodes)

Can save episode without media, but can't publish it


[Itunes podcast specification](https://www.apple.com/itunes/podcasts/specs.html#rss)



