defmodule SnifflingBot.Storage do
  @table :sniffling_ets_table

  def init do
    :ets.new(@table, [:set, :public, :named_table])
  end

  def store(discord_user_id, github_access_token) do
    :ets.insert(@table, {discord_user_id, github_access_token})
  end

  def get_token(discord_user_id) do
    case :ets.lookup(@table, discord_user_id) do
      [{_, token}] -> {:ok, token}
      _ -> {:error, "No token found for user."}
    end
  end
end
