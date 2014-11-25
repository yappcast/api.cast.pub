defmodule YappCast.Queries.Categories do
  import Ecto.Query
  alias YappCast.Models.Category
  alias YappCast.Models.SubCategory
  alias YappCast.Queries.SubCategories
  alias YappCast.Repo

  def get(id) do
    Repo.get(Category, id)
  end

  def list() do
    query = from u in Category, select: u, preload: :sub_categories
    Repo.all(query)
  end

  def create(category) do
    YappCast.Queries.create(category)
  end

  def update(id, data) do
    case get(id) do
      nil ->
        {:error, [{:error, :category, :category, "category not found"}]}
      updating_category ->
        updating_category
        |> YappCast.Queries.update_map_with_params(data, [:title])
        |> YappCast.Queries.update
    end
  end

  def delete(id) do
    Repo.get(Category, id)
    |> Repo.delete
  end

  def seed() do

    case list() do
      [] ->
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

        Enum.each(categories, fn(category) ->
          {:ok, saved_category } = Categories.create(%Category{ title: category.title })

          Enum.each(category.sub_categories, fn(sub_category) ->
            {:ok, saved_sub_category } = Categories.create(%SubCategory{ title: sub_category, category_id: saved_category.id })
          end)

        end)
      _ ->
    end
  end
end