defmodule YappCast.Models.Podcast do
  use Ecto.Model
  use Vex.Struct

  schema "podcasts" do
    field :title, :string
    field :link, :string
    field :copyright, :string
    field :author, :string
    field :block, :boolean, default: false
    field :image_url, :string
    field :explicit, :boolean, default: false
    field :complete, :boolean, default: false
    field :new_feed_url, :string
    field :owner, :string
    field :owner_email, :string
    field :subtitle, :string
    field :summary, :string
    belongs_to :user, YappCast.Models.User
    has_many :episodes, YappCast.Models.Episode
    has_many :categories, YappCast.Models.Podcast.Category
    has_many :permission_groups, YappCast.Models.Podcast.PermissionGroup
  end

  validates :title, presence: true, length: [max: 255]
  validates :owner, presence: true, length: [max: 255]
  validates :owner_email, presence: true, length: [max: 255]
  validates :link, length: [max: 255]
  validates :copyright, length: [max: 255]
  validates :author, length: [max: 255]
  validates :image_url, length: [max: 255]
  validates :new_feed_url, length: [max: 255]
  validates :subtitle, length: [max: 255]
end