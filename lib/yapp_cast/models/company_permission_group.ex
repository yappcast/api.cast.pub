defmodule YappCast.Models.CompanyPermissionGroup do
  use Ecto.Model  
  use Vex.Struct

  schema "company_permission_group" do
    field :title, :string
    belongs_to :company, YappCast.Models.Company
    has_many :members, YappCast.Models.CompanyPermissionGroupMember
  end

  validates :title, presence: true, length: [max: 255]
end