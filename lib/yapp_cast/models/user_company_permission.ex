defmodule YappCast.Models.UserCompanyPermission do
  use Ecto.Model

  schema "user_company_permissions" do
    belongs_to :user, YappCast.Models.User
    belongs_to :company, YappCast.Models.Company
    field :can_add, :boolean
    field :can_edit, :boolean
    field :can_delete, :boolean
  end
end