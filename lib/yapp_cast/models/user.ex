defmodule YappCast.Models.User do
  use Ecto.Model

  schema "users" do
    field :username, :string
    field :email, :string
    has_many :companies, YappCast.Models.Company
    has_many :user_company_permissions, YappCast.Models.UserCompanyPermission
    has_many :user_podcast_permissions, YappCast.Models.UserPodcastPermission
  end
end