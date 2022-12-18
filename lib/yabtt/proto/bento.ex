defimpl Bento.Encoder, for: YaBTT.Proto.Peered do
  @moduledoc """
  Implementation of `Bento.Encoder` protocol for `YaBTT.Proto.Peered` struct.
  """

  alias Bento.Encoder
  alias YaBTT.Proto.Peered
  use Bento.Encode

  @doc """
  Encode the Peered struct into its Bencoding form.

  ## Parameters
    - peer: The `YaBTT.Proto.Peered` struct to be encoded.

  ## Example
      iex> struct(YaBTT.Proto.Peered, %{})
      ...> |> Bento.Encoder.YaBTT.Proto.Peered.encode()
      ...> |> IO.iodata_to_binary()
      "d2:ip4:null4:port4:null7:peer id4:nulle"

      iex> struct(YaBTT.Proto.Peered, %{peer_id: "peer_id"})
      ...> |> Bento.Encoder.YaBTT.Proto.Peered.encode()
      ...> |> IO.iodata_to_binary()
      "d2:ip4:null4:port4:null7:peer id7:peer_ide"

  """
  @spec encode(Peered.t()) :: Encoder.t()
  def encode(peer) do
    Map.from_struct(peer)
    |> Map.put("peer id", peer.peer_id)
    |> Map.delete(:peer_id)
    |> Encoder.Map.encode()
  end
end

defimpl Bento.Encoder, for: YaBTT.Server.Resp do
  @moduledoc """
  Implementation of `Bento.Encoder` protocol for `YaBTT.Server.Resp` struct.
  """

  alias Bento.Encoder
  alias YaBTT.Server.Resp
  use Bento.Encode

  @doc """
  Encode the Resp struct into its Bencoding form.

  ## Parameters
    - resp: The `YaBTT.Server.Resp` struct to be encoded.

  ## Example
      iex> struct(YaBTT.Server.Resp, %{})
      ...> |> Bento.Encoder.YaBTT.Server.Resp.encode()
      ...> |> IO.iodata_to_binary()
      "d8:intervali3600e5:peerslee"

      iex> %YaBTT.Server.Resp{
      ...>   interval: 3600,
      ...>   peers: [
      ...>     %YaBTT.Proto.Peered{peer_id: "peer_id", ip: {1, 2, 3, 4}, port: 6881}
      ...>   ]
      ...> } |> Bento.Encoder.YaBTT.Server.Resp.encode() |> IO.iodata_to_binary()
      "d8:intervali3600e5:peersld2:ip7:1.2.3.44:porti6881e7:peer id7:peer_ideee"
  """
  @spec encode(Resp.t()) :: Encoder.t()
  def encode(resp), do: Map.from_struct(resp) |> Encoder.Map.encode()
end

defimpl Bento.Encoder, for: Tuple do
  @moduledoc """
  Implementation of `Bento.Encoder` protocol for `Tuple` struct.
  """

  alias Bento.Encoder
  use Bento.Encode

  @doc """
  Encode the Tuple into its Bencoding form. If the tuple is an IP address,
  it will be encoded as a BitString.

  ## Parameters
    - tuple: The `Tuple` to be encoded.

  ## Example
      iex> {1, 2, 3, 4} |> Bento.Encoder.Tuple.encode() |> IO.iodata_to_binary()
      "7:1.2.3.4"

      iex> {:a, :b, :c, :d} |> Bento.Encoder.Tuple.encode() |> IO.iodata_to_binary()
      "l1:a1:b1:c1:de"
  """
  @spec encode(Tuple.t()) :: Encoder.t()
  def encode(tuple) do
    if :inet.is_ip_address(tuple) do
      :inet.ntoa(tuple) |> to_string() |> Encoder.BitString.encode()
    else
      Tuple.to_list(tuple) |> Encoder.List.encode()
    end
  end
end