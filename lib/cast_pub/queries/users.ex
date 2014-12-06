defmodule CastPub.Queries.Users do
  import Ecto.Query
  alias CastPub.Models.User
  alias CastPub.Repo
  alias CastPub.Auth

  def get(id) do
    Repo.get(User, id)
  end

  def get_by_email(email) do
    query = from u in User,
          where: u.email == ^email,
         select: u

    Repo.one(query)
  end

  def create(user) do
    case Vex.errors(user) do
      [] ->
        user = %{ user | password: Auth.encrypt_password(user.password) }
        {:ok, Repo.insert(user)}
      errors ->
        {:error, errors}       
    end
  end

  def update(id, email, password, name) do
    case get(id) do
      nil ->
        {:error, [{:error, :user, :user, "user not found"}]}
      updating_user ->
        if email do
          updating_user = %{updating_user | email: email }
        end

        if password do
          updating_user = %{updating_user | password: password }
        end

        if name do
          updating_user = %{updating_user | name: name }
        end

        case Vex.errors(updating_user) do
          [] ->
            user = %{ updating_user | password: Auth.encrypt_password(updating_user.password) }
            {:ok, Repo.update(user)}
          errors ->
            {:error, errors}       
        end
    end
  end

  def delete(id) do
    Repo.get(User, id)
    |> Repo.delete
  end

  def credentials_ok?(email, password) do
    case get_by_email(email) do
      nil ->
        false
      user ->
        Auth.check_password(password, user.password)
    end
  end
end