defmodule YappCast.Models.CompanyPermissionGroupMember do
  use Ecto.Model

  schema "company_permission_group_member" do
    belongs_to :group, YappCast.Models.CompanyPermissionGroup
    belongs_to :user, YappCast.Models.User
  end
end