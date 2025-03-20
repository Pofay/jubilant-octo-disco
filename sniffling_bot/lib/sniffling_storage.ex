defmodule SnifflingBot.Storage do
  @access_token_table :sniffling_ets_token_table
  @gist_id_table :sniffling_ets_gist_id_table
  @pagination_state_table :sniffling_ets_pagination_state_table

  def init do
    :ets.new(@access_token_table, [:set, :public, :named_table])
    :ets.new(@gist_id_table, [:set, :public, :named_table])
    :ets.new(@pagination_state_table, [:set, :public, :named_table])
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

  def store_gist_info(discord_user_id, gist_information) do
    :ets.insert(@gist_id_table, {discord_user_id, gist_information})
  end

  def get_gist_information(discord_user_id) do
    case :ets.lookup(@gist_id_table, discord_user_id) do
      [{_, gist_information}] -> {:ok, gist_information}
      _ -> {:error, "No gist ID found for user."}
    end
  end

  def store_pagination_state(discord_user_id, links, pageNumber) do
    IO.puts "Storing pagination state for user #{discord_user_id}"
    :ets.insert(@pagination_state_table, {discord_user_id, links, pageNumber})
  end

  def get_pagination_state(discord_user_id) do
    IO.puts "Getting pagination state for user #{discord_user_id}"
    case :ets.lookup(@pagination_state_table, discord_user_id) do
      [{_, links, pageNumber}] -> {:ok, {links, pageNumber}}
      _ -> {:error, "No pagination state found for user."}
    end
  end

  def update_pagination_state(discord_user_id, links, pageNumber) do
    with {:ok, {_, _}} <- get_pagination_state(discord_user_id) do
      :ets.delete(@pagination_state_table, discord_user_id)
      store_pagination_state(discord_user_id, links, pageNumber)
    else
      {:error, _} -> {:error, "No pagination state found for user."}
    end
  end
end
