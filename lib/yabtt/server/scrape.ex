defmodule YaBTT.Server.Scrape do
  @moduledoc false

  @behaviour Plug

  import YaBTT.Server.Announce
  import Plug.Conn

  @doc """
  Initializes the plug.
  """
  @spec init(Plug.opts()) :: Plug.opts()
  def init(opts), do: opts

  @doc """
  The main entry point for the plug.
  """
  @spec call(Plug.Conn.t(), Plug.opts()) :: Plug.Conn.t()
  def call(conn, _opts) do
    res = fetch_info_hashs(conn.query_string) |> YaBTT.query_state()

    conn
    |> put_resp_content_type("text/plain")
    |> put_resp_msg({:ok, res})
    |> send_resp()
  end

  @spec fetch_info_hashs(String.t()) :: [String.t()]
  defp fetch_info_hashs(call) do
    String.splitter(call, "&", trim: true)
    |> Enum.reduce([], fn param, acc ->
      case String.split_at(param, 10) do
        {"info_hash=", v} -> [URI.decode(v) | acc]
        _ -> acc
      end
    end)
  end
end