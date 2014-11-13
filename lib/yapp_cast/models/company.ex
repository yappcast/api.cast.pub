defmodule YappCast.Models.Company do
  use Ecto.Model

  schema "companies" do
    field :name, :string
    field :slug, :string
    belongs_to :owner, YappCast.Models.User
    has_many :podcasts, YappCast.Models.Podcast
    has_many :user_company_permissions, YappCast.Models.UserCompanyPermission
  end
end