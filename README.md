# YappCast

To start your new Phoenix application:

1. Install dependencies with `mix deps.get`
2. Start Phoenix router with `mix phoenix.start`

Now you can visit `localhost:4000` from your browser.

# Migrations
TO create a migration, do: `mix ecto.gen.migration YappCast.Repo <migration_name>`
To run migrations, do: `mix ecto.migrate YappCast.Repo`

do `mix help` to see all the commands that are available


User(s)
  UserPodcastPermission(s)
  UserCompanyPermission(s)
  Company(s)
    Podcast(s)
      Episode(s)


url = base_url/<company_slug>/<podcast_slug>/<episode>.mp3


User signs up
User creates Company. Company essentially is a group of podcasts
User can invite other users to Company
User can give Permissions to Podcast/Company for invited Users

Data saved on user's own S3 instance (cover art, episodes)

Can save episode without media, but can't publish it

User
  * id        : Int
  * username  : String
  * email     : String

Company
  * id    : Int
  * name  : String
  * slug  : String
  * owner : User
  * s3_api_key: String

Podcast
  * id        : Int
  * name      : String
  * slug      : String
  * company   : Company
  * s3_api_key: String //overrides the one used in company if specified
  * cover_url : String

Episode
  * id    : Int
  * name  : String
  * media_url : String
  * published : Boolean

UserPodcastPermission
  * user : User
  * podcast : Podcast
  * can_view : Boolean
  * can_add : Boolean
  * can_edit : Boolean
  * can_delete : Boolean

UserCompanyPermission
  * user : User
  * company : Company
  * can_add : Boolean
  * can_edit : Boolean
  * can_delete : Boolean



