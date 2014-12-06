defmodule CastPub.Auth do
  
  def encrypt_password(password) do
    password = String.to_char_list(password)
    work_factor = Application.get_env(:yapp_cast, :password_work_factor)
    {:ok, salt} = :bcrypt.gen_salt(work_factor)
    {:ok, hash} = :bcrypt.hashpw(password, salt)
    :erlang.list_to_binary(hash)
  end

  def check_password(password, password_hash) do
    password = String.to_char_list(password)
    {:ok, hash} = :bcrypt.hashpw(password, password_hash)
    hash = :erlang.list_to_binary(hash)
    secure_compare(hash, password_hash)
  end

  @doc """
  from: https://github.com/hexpm/hex_web
  Compares the two binaries in constant-time to avoid timing attacks.

  See: http://codahale.com/a-lesson-in-timing-attacks/
  """
  defp secure_compare(left, right) do
    if byte_size(left) == byte_size(right) do
      arithmetic_compare(left, right, 0) == 0
    else
      false
    end
  end

  defp arithmetic_compare(<<x, left :: binary>>, <<y, right :: binary>>, acc) do
    import Bitwise
    arithmetic_compare(left, right, acc ||| (x ^^^ y))
  end

  defp arithmetic_compare("", "", acc) do
    acc
  end
end