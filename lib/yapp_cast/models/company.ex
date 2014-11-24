defmodule YappCast.Models.Company do
  use Ecto.Model
  use Vex.Struct

  schema "companies" do
    field :title, :string
    field :slug, :string
    belongs_to :user, YappCast.Models.User
    has_many :podcasts, YappCast.Models.Podcast
    has_many :permission_groups, YappCast.Models.CompanyPermissionGroup
  end

  validates :title, presence: true, length: [max: 255]
  validates :slug, presence: true, length: [max: 255]
  validates :user_id, presence: true
end