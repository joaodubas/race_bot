defmodule F1Bot.Ets do
  def new(table_name) do
    :ets.new(table_name, [:named_table, :public, :set, read_concurrency: true])
  end

  def fetch(table_name, key) do
    case :ets.lookup(table_name, key) do
      [{^key, value}] ->
        {:ok, value}

      _ ->
        {:error, :no_data}
    end
  end

  def insert(table_name, key, value) do
    :ets.insert(table_name, {key, value})
  end
end
