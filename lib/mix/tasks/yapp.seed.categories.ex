defmodule Mix.Tasks.Yapp.Seed.Categories do
  use Mix.Task

  @shortdoc "Seeds the Categories"

  @moduledoc """
  Seeds the Categories.
  https://itunes.apple.com/us/genre/podcasts/id26

  ## Command line options

  * `--no-start` - do not start applications

  ## Examples

      mix yapp.seed.categories

  """
  def run(args) do
    Mix.Task.run "app.start", args

    categories = [
      %{ 
        title: "Arts", 
        sub_categories: ["Design", "Fasion & Beauty", "Food", "Literature", "Performing Arts", "Visual Arts"]
      },
      %{ 
        title: "Business", 
        sub_categories: ["Business News", "Careers", "Investing", "Management & Marketing", "Shopping"]
      },
      %{ 
        title: "Comedy", 
        sub_categories: []
      },
      %{ 
        title: "Education", 
        sub_categories: ["Education Technology", "Higher Education", "K-12", "Language Courses", "Training"]
      },
      %{ 
        title: "Games & Hobbies", 
        sub_categories: ["Automotive", "Aviation", "Hobbies", "Other Games", "Video Games"]
      },
      %{ 
        title: "Government & Organizations", 
        sub_categories: ["Local", "National", "Non-Profit", "Regional"]
      },
      %{ 
        title: "Health", 
        sub_categories: ["Alternative Health", "Fitness & Nutrition", "Self-Help", "Sexuality"]
      },
      %{ 
        title: "Kids & Family", 
        sub_categories: []
      },
      %{ 
        title: "Music", 
        sub_categories: []
      },
      %{ 
        title: "News & Politics", 
        sub_categories: []
      },
      %{ 
        title: "Religion & Spirituality", 
        sub_categories: ["Buddhism", "Christianity", "Hinduism", "Islam", "Judaism", "Other", "Spirituality"]
      },
      %{ 
        title: "Science & Medicine", 
        sub_categories: ["Medicine", "Natural Sciences", "Social Sciences"]
      },
      %{ 
        title: "Society & Culture", 
        sub_categories: ["History", "Personal Journals", "Philosophy", "Places & Travel"]
      },
      %{ 
        title: "Sports & Recreation", 
        sub_categories: ["Amateur", "College & High School", "Outdoor", "Professional"]
      },
      %{ 
        title: "TV & Film", 
        sub_categories: []
      },
      %{ 
        title: "Technology", 
        sub_categories: ["Gadgets", "Podcasting", "Software How-To", "Tech News"]
      }
    ]

    Mix.shell.info "Categories would be seeded now if this were implemented"
  end
end
