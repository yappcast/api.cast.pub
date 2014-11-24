defmodule YappCast.Queries do
  alias YappCast.Repo
  
  def update_map_with_params(input, params, key_whitelist) do
  {_, output} = Enum.map_reduce(key_whitelist, input, 
    fn(key, m) -> 
      if Dict.has_key?(params, key) && params[key] != nil do
        { key, Map.put(m, key, params[key]) }
      else
        { key, m }
      end
    end)

    output
  end

  def create(item) do
    case Vex.errors(item) do
      [] ->
        {:ok, Repo.insert(item)}
      errors ->
        {:error, errors}       
    end
  end

  def update(item) do
    case Vex.errors(item) do
      [] ->
        {:ok, Repo.update(item)}
      errors ->
        {:error, errors}       
    end
  end
end