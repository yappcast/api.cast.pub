defmodule Mix.Tasks.App.Gen.Data do
  use Mix.Task
  
 @shortdoc "Generates Fake Data"

  def run(args) do
    Mix.Task.run "app.start", args

    users = create_fake_users(10)
    podcasts = create_fake_podcasts(users, 5, 20)
  end

  defp create_fake_users(number_of_users) do

    Enum.map(0..number_of_users, fn(x) ->

      {:ok, user} = %CastPub.Models.User{
        email: Faker.Internet.email, 
        password: "password", 
        name: Faker.Name.name
      }
      |> CastPub.Queries.Users.create

      user
    end)

  end

  defp create_fake_podcasts(users, number_of_podcasts, number_of_episodes) do

    Enum.map(users, fn(x) ->

      podcasts = Enum.map(0..number_of_podcasts, fn(y) ->
        {:ok, podcast} = %CastPub.Models.Podcast{
          title: Faker.Lorem.sentences(1) |> Enum.join(" "),
          link: Faker.Internet.url,
          copyright: Faker.Company.name,
          author: x.name,
          block: false,
          image_url: Faker.Internet.image_url,
          explicit: false,
          complete: false,
          new_feed_url: nil,
          owner: x.name,
          owner_email: x.email,
          subtitle: Faker.Lorem.sentences(1) |> Enum.join(" "),
          summary: Faker.Lorem.sentences(2) |> Enum.join(" "),
          user_id: x.id
        }
        |> CastPub.Queries.Podcasts.create([1,2,4])

        Enum.map(0..number_of_episodes, fn(z) -> 

          %CastPub.Models.Episode{
            title: Faker.Lorem.sentences(1) |> Enum.join(" "),
            publish_date: Ecto.DateTime.utc,
            author: podcast.author,
            block: false,
            image_url: Faker.Internet.image_url,
            duration: "0:30",
            explicit: false,
            is_closed_captioned: false,
            order: nil,
            subtitle: Faker.Lorem.sentences(1) |> Enum.join(" "),
            summary: Faker.Lorem.sentences(2) |> Enum.join(" "),
            media_url: Faker.Internet.url,
            podcast_id: podcast.id
          }
          |> CastPub.Queries.Episodes.create

        end)

        podcast

      end)

      {x, podcasts}
    end)

  end
end