defmodule YappCast.Models.Company.PermissionGroupMember do
  use Ecto.Model

  schema "company_permission_group_member" do
    belongs_to :group, YappCast.Models.Company.PermissionGroup
    belongs_to :user, YappCast.Models.User
  end
end