defmodule SnifflingBot.Storage do
  @access_token_table :sniffling_ets_token_table
  @gist_id_table :sniffling_ets_gist_id_table

  def init do
    :ets.new(@access_token_table, [:set, :public, :named_table])
    :ets.new(@gist_id_table, [:set, :public, :named_table])
  end

  def store_token(discord_user_id, github_access_token) do
    :ets.insert(@access_token_table, {discord_user_id, github_access_token})
  end

  def get_token(discord_user_id) do
    case :ets.lookup(@access_token_table, discord_user_id) do
      [{_, token}] -> {:ok, token}
      _ -> {:error, "No token found for user."}
    end
  end

  def store_gist_id(discord_user_id, gist_id) do
    :ets.insert(@gist_id_table, {discord_user_id, gist_id})
  end
end
