defmodule YaBTT.Schema.Peer do
  @moduledoc """
  The schema for a peer.

  A peer is a client that is connected to a torrent. It is identified by a
  unique peer_id, which is a 20-byte string. The peer_id is generated by the
  client and is not necessarily unique. The ip and port are used to connect
  to the peer. The ip is optional, and if not provided, the ip of the
  connection is used. The port is required.

  A peer can be connected to many torrents, and a torrent can have many peers.

  ## Fields

    * `peer_id` - The peer_id of the peer.
    * `ip` - The ip of the peer.
    * `port` - The port of the peer.
    * `inserted_at` - The time the peer was inserted.
    * `updated_at` - The time the peer was last updated.

  ## Associations

    * `torrents` - The torrents the peer is connected to.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias YaBTT.Schema.{Connection, Torrent}

  @primary_key {:id, :id, autogenerate: true}
  schema "peers" do
    field(:peer_id, :binary_id)
    field(:ip, :binary)
    field(:port, :integer)
    many_to_many(:torrents, Torrent, join_through: Connection)

    timestamps()
  end

  @type t :: %__MODULE__{}
  @type changeset_t :: Ecto.Changeset.t(t())
  @type ip_addr :: :inet.ip_address()
  @type params :: map()

  @doc """
  A peer can be created or updated with a changeset. The changeset requires
  the peer_id and port to be present. The ip is optional, and if not provided,
  the ip of the connection is used.

  ## Parameters

    * `peer` - The peer to create a changeset for.
    * `conn` - The connection to get the ip from.

  ## Examples

      iex> alias YaBTT.Schema.Peer
      iex> params = %{"peer_id" => "-TR14276775888084598", "port" => "6881", "ip" => "1.2.3.5"}
      iex> Peer.changeset(%Peer{}, params, {1, 2, 3, 4})
      #Ecto.Changeset<action: nil, changes: %{ip: \"1.2.3.5\", peer_id: \"-TR14276775888084598\", port: 6881}, errors: [], data: #YaBTT.Schema.Peer<>, valid?: true>

      iex> alias YaBTT.Schema.Peer
      iex> Peer.changeset(%Peer{}, %{}, {1, 2, 3, 4})
      #Ecto.Changeset<action: nil, changes: %{ip: \"1.2.3.4\"}, errors: [peer_id: {\"can't be blank\", [validation: :required]}, port: {\"can't be blank\", [validation: :required]}], data: #YaBTT.Schema.Peer<>, valid?: false>
  """
  @spec changeset(changeset_t() | t(), params(), ip_addr()) :: changeset_t()
  def changeset(peer, params, ip) do
    peer
    |> cast(params, [:peer_id, :ip, :port])
    |> validate_required([:peer_id, :port])
    |> handle_ip(ip)
  end

  @spec handle_ip(changeset_t(), ip_addr()) :: changeset_t()
  defp handle_ip(changeset, remote_ip) do
    with {:ok, ip} <- fetch_change(changeset, :ip),
         {:ok, ip} <- :inet.parse_address(to_charlist(ip)) do
      ip |> :inet.ntoa() |> to_string()
    else
      _ -> remote_ip |> :inet.ntoa() |> to_string()
    end
    |> (&put_change(changeset, :ip, &1)).()
  end

  defimpl Bento.Encoder do
    @moduledoc """
    Implements the `Bento.Encoder` protocol for `YaBTT.Schema.Peer`.
    """

    use Bento.Encode

    alias YaBTT.Schema.Peer
    alias Bento.Encoder

    @doc """
    To encode a peer, we take the `peer_id`, `ip`, and `port` into a map and
    encode it by calling `Bento.Encoder.encode/1` on the map.

    ## Examples

        iex> alias YaBTT.Schema.Peer
        iex> peer = %Peer{peer_id: "-TR14276775888084598", port: 6881, ip: "1.2.3.5"}
        iex> Bento.Encoder.encode(peer) |> IO.iodata_to_binary()
        "d2:ip7:1.2.3.57:peer id20:-TR142767758880845984:porti6881ee"
    """
    @spec encode(Peer.t()) :: Encoder.t()
    def encode(%{id: _} = peer) do
      peer
      |> Map.take([:peer_id, :ip, :port])
      |> do_encode()
      |> Encoder.encode()
    end

    defp do_encode(map_with_atom_keys) do
      for {k, v} <- map_with_atom_keys, into: %{} do
        {Atom.to_string(k) |> String.replace("_", " "), v}
      end
    end
  end
end
