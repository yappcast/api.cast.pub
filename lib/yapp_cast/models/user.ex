defmodule YappCast.Models.User do
  use Ecto.Model
  use Vex.Struct

  schema "users" do
    field :email, :string
    field :password, :string
    has_many :companies, YappCast.Models.Company
    has_many :user_company_permissions, YappCast.Models.UserCompanyPermission
    has_many :user_podcast_permissions, YappCast.Models.UserPodcastPermission
  end

  validates :email, presence: true, length: [max: 255]
  validates :password, presence: true

  defimpl Canada.Can, for: YappCast.Models.User do
    def can?(user, action, the_user = %YappCast.Models.User{id: id}) when action in [:get, :post, :put, :delete] do
      user.id == the_user.id
    end

    def can?(user, :get, company = %YappCast.Models.Company{}) do
      true
    end

    def can?(user, _, company = %YappCast.Models.Company{}) do
      user.id == company.user_id
    end
    
  end
end